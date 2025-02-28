import { Router } from "express";
import {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  uploadAvatar,
  deleteAvatar,
} from "../controllers/user.controller";
import upload from "../middleware/upload";

const router = Router();

router.get("/", getUsers);
router.get("/:id", getUserById);
router.post("/", createUser);
router.put("/:id", updateUser);
router.delete("/:id", deleteUser);
router.delete("/delete-avatar/:id", deleteAvatar);
router.post("/upload-avatar/:id", upload.single("avatar"), uploadAvatar);

export default router;
