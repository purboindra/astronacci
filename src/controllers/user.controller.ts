import { Request, Response } from "express";
import UserModel from "../models/user.model";
import cloudinary from "../config/cloudinary";
import multer from "multer";

interface MulterRequest extends Request {
  file?: Express.Multer.File;
}

export const getUsers = async (req: Request, res: Response) => {
  try {
    const users = await UserModel.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: "Error fetching users", error });
  }
};

export const getUserById = async (req: Request, res: Response) => {
  try {
    const user = await UserModel.findById(req.params.id);
    if (!user) res.status(404).json({ message: "User not found" });
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: "Error fetching user", error });
  }
};

export const createUser = async (req: Request, res: Response) => {
  try {
    const { name, email, address, age, avatar = null } = req.body;

    if (!name) {
      res.status(400).json({ message: "Name are required" });
    }

    if (!email) {
      res.status(400).json({ message: "Email are required" });
    }

    if (!address) {
      res.status(400).json({ message: "Address are required" });
    }

    if (!age) {
      res.status(400).json({ message: "Age are required" });
    }

    const newUser = new UserModel({ name, email, avatar, address, age });
    await newUser.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(500).json({ message: "Error creating user", error });
  }
};

export const updateUser = async (req: Request, res: Response) => {
  try {
    const updatedUser = await UserModel.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true },
    );
    if (!updatedUser) res.status(404).json({ message: "User not found" });
    res.json(updatedUser);
  } catch (error) {
    res.status(500).json({ message: "Error updating user", error });
  }
};

export const deleteUser = async (req: Request, res: Response) => {
  try {
    const deletedUser = await UserModel.findByIdAndDelete(req.params.id);
    if (!deletedUser) res.status(404).json({ message: "User not found" });
    res.json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting user", error });
  }
};

export const uploadAvatar = async (req: Request, res: Response) => {
  try {
    const userId = req.params.id;

    if (!userId) {
      res.status(400).json({ message: "User id is required" });
      return;
    }

    const file = req?.file;

    if (!file) {
      res.status(400).json({ message: "File is required" });
      return;
    }

    const result = await cloudinary.uploader.upload(file.path, {
      public_id: "avatars",
    });

    const optimizeUrl = cloudinary.url("avatars", {
      fetch_format: "auto",
      quality: "auto",
    });

    console.log(optimizeUrl);

    const autoCropUrl = cloudinary.url("avatars", {
      crop: "auto",
      gravity: "auto",
      width: 500,
      height: 500,
    });

    const user = await UserModel.findByIdAndUpdate(
      userId,
      { avatar: result.secure_url },
      { new: true },
    );

    res.status(200).json({
      message: "Avatar uploaded successfully",
      avatar: user?.avatar,
    });
  } catch (error) {
    console.error("Error upload avatar", error);
    res.status(500).json({
      message: "Error upload avatar",
    });
  }
};
