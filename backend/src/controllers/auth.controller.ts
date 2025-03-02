import { Request, Response } from "express";
import UserModel from "../models/user.model";
import crypto from "crypto";
import nodemailer from "nodemailer";
import jwt from "jsonwebtoken";

const SECRET_KEY = process.env.JWT_SECRET_KEY;

export const register = async (req: Request, res: Response) => {
  try {
    const { name, email, address, age, avatar = null, password } = req.body;

    if (!email || !password) {
      res.status(400).json({ message: "Email and password are required" });
    }

    if (!name || !address || !age) {
      res.status(400).json({ message: "Name, address, and age are required" });
    }

    const existingUser = await UserModel.findOne({ email });

    if (existingUser) {
      res.status(400).json({ message: "User already exists/registered" });
    }

    const user = new UserModel({
      name,
      email,
      address,
      age,
      avatar,
      password,
    });

    await user.save();

    const token = jwt.sign(
      {
        userId: user._id,
        email: user.email,
        name: user.name,
      },
      SECRET_KEY!,
      { expiresIn: "1d" }
    );

    user.access_token = token;
    await user.save();

    res.status(201).json({
      message: "User registered in successfully",
      user: {
        name: user.name,
        email: user.email,
        address: user.address,
        age: user.age,
        avatar: user.avatar,
        access_token: token,
      },
    });
  } catch (error) {
    console.error("Error register", error);
    res.status(500).json({ message: "Unkown error occured!" });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      res.status(400).json({ message: "Email and password are required" });
      return;
    }

    const findUser = await UserModel.findOne({ email });

    if (!findUser) {
      res.status(401).json({ message: "User not found/registered" });
      return;
    }

    const isMatch = await findUser.comparePassword(password);

    if (!isMatch) {
      res.status(401).json({ message: "Invalid credentials" });
      return;
    }

    const token = jwt.sign(
      {
        userId: findUser._id,
        email: findUser.email,
        name: findUser.name,
      },
      SECRET_KEY!,
      { expiresIn: "1d" }
    );

    res.status(201).json({
      message: "User logged in successfully",
      user: {
        name: findUser.name,
        email: findUser.email,
        address: findUser.address,
        age: findUser.age,
        avatar: findUser.avatar,
        access_token: token,
      },
    });
  } catch (error) {
    console.error("Error login", error);

    res.status(500).json({ message: "Unkown error occured!" });
  }
};

export const forgotPassword = async (req: Request, res: Response) => {
  try {
    const { email } = req.body;

    if (!email) {
      res.status(400).json({ message: "Email is required" });
    }

    let user = await UserModel.findOne({ email });

    if (!user) {
      res.status(404).json({ message: "User not found" });
    }

    const resetToken = crypto.randomBytes(32).toString("hex");
    const resetTokenExpire = new Date(Date.now() + 360000);

    user!.resetPasswordToken = resetToken;
    user!.resetPasswordExpires = resetTokenExpire;

    await user?.save();

    const transporter = nodemailer.createTransport({
      service: "Gmail",
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    console.log("Reset token", resetToken);

    const resetLink = `http://localhost:3000/api/auth/reset-password/${resetToken}`;

    await transporter.sendMail({
      to: user!.email,
      subject: "Password Reset Request",
      html: `<p>You requested a password reset. Click <a href="${resetLink}">here</a> to reset your password.</p>`,
    });

    res.status(200).json({ message: "Reset password email sent." });
  } catch (error) {
    console.error("Error forgot password", error);
    res.status(500).json({ message: "Error sending reset email", error });
  }
};

export const resetPassword = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { token } = req.params;
    const { newPassword } = req.body;

    if (!token || !newPassword) {
      res.status(400).json({ message: "Token and new password are required" });
      return;
    }

    const user = await UserModel.findOne({
      resetPasswordToken: token,
      resetPasswordExpires: { $gt: new Date() },
    });

    if (!user) {
      res.status(400).json({ message: "Invalid or expired user token" });
      return;
    }

    user.password = newPassword;

    await user?.save();

    user!.resetPasswordExpires = undefined;
    user!.resetPasswordToken = undefined;

    res.status(200).json({ message: "Password reset successfully" });
  } catch (error) {
    console.error("Error reset password", error);
    res.status(500).json({ message: "Error resetting password", error });
  }
};
