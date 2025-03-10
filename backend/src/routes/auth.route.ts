import { Router } from "express";

import {
  register,
  login,
  forgotPassword,
  resetPassword,
  logout,
} from "../controllers/auth.controller";

const router = Router();

router.post("/register", register);
router.post("/logout", logout);
router.post("/login", login);
router.post("/forgot-password", forgotPassword);
router.post("/reset-password/:token", resetPassword);

export default router;
