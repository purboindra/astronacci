import { Request, Response } from "express";
import UserModel from "../models/user.model";
import cloudinary from "../config/cloudinary";
import { error } from "console";
import fs from "fs";

interface MulterRequest extends Request {
  file?: Express.Multer.File;
}

export const getUsers = async (req: Request, res: Response) => {
  try {
    const query = String(req.query.query || "");
    const page = parseInt(req.query.page as string) || 1;
    const limit = Math.min(parseInt(req.query.limit as string) || 10, 50);
    const skip = (page - 1) * limit;

    let users = [];
    let totalUsers = 0;

    if (query.trim()) {
      users = await UserModel.find({
        $or: [
          { name: { $regex: query, $options: "i" } }, // ✅ Case-insensitive search
          { email: { $regex: query, $options: "i" } },
        ],
      })
        .skip(skip)
        .limit(limit);

      totalUsers = await UserModel.countDocuments({
        $or: [
          { name: { $regex: query, $options: "i" } },
          { email: { $regex: query, $options: "i" } },
          { address: { $regex: query, $options: "i" } },
        ],
      });
    } else {
      users = await UserModel.find().skip(skip).limit(limit);
      totalUsers = await UserModel.countDocuments();
    }

    if (!users || users.length === 0) {
      res.status(404).json({ message: "User not found" });
    } else {
      res.status(200).json({
        totalUsers,
        page,
        limit,
        totalPages: Math.ceil(totalUsers / limit),
        users,
      });
    }
  } catch (error) {
    res.status(500).json({ message: "Error fetching users", error });
  }
};

export const getUserById = async (req: Request, res: Response) => {
  try {
    const user = await UserModel.findById(req.params.id);
    if (!user) res.status(404).json({ message: "User not found" });
    res.status(200).json(user);
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
    if (!req.params.id) {
      res.status(400).json({ message: "User id is required" });
      return;
    }

    if (!req.body) {
      res.status(400).json({ message: "User data is required" });
      return;
    }

    const user = await UserModel.findById(req.params.id);

    if (!user) {
      res.status(404).json({ message: "User not found" });
      return;
    }

    const avatar = await uploadAvatar(req, res);

    const { address, age, name } = req.body;

    const updatedUser = await UserModel.findByIdAndUpdate(
      req.params.id,
      {
        address: address ?? user.address,
        age: age ?? user.age,
        name: name ?? user.name,
      },
      { new: true }
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

export const deleteAvatar = async (req: Request, res: Response) => {
  try {
    if (!req.params.id) {
      res.status(400).json({ message: "User id is required" });
      return;
    }

    const user = await UserModel.findById(req.params.id);

    if (!user) {
      res.status(404).json({ message: "User not found" });
      return;
    }

    if (!user.avatar) {
      res.status(404).json({ message: "Avatar not found" });
      return;
    }

    const findPublicId = user.avatar.split("/").pop()?.split(".")[0];

    cloudinary.uploader
      .destroy(`avatars/${req.params.id}/${findPublicId}`)
      .then(async () => {
        user.avatar = null;
        await user.save();
        res.status(200).json({ message: "Avatar deleted successfully" });
      })
      .catch((error) => {
        console.error("Error delete avatar", error);
        res.status(500).json({ message: "Error delete avatar" });
      });
  } catch (e) {
    console.error("Error delete avatar", error);
    res.status(500).json({ message: "Error delete avatar" });
  }
};

export const uploadAvatar = async (req: MulterRequest, res: Response) => {
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

    const cloudinaryUrl = await uploadToCloudinary(file, userId);

    const user = await UserModel.findByIdAndUpdate(
      userId,
      { avatar: cloudinaryUrl },
      { new: true }
    );

    fs.unlink(req.file!.path, (err) => {
      if (err) {
        console.error("Error deleting file", err);
      }
    });

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

const uploadToCloudinary = async (
  file: Express.Multer.File,
  userId: string
) => {
  const uniquePublicId = `avatars/${userId}/${Date.now()}`;

  const result = await cloudinary.uploader.upload(file.path, {
    public_id: uniquePublicId,
  });

  console.log(result);

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

  return result.secure_url;
};
