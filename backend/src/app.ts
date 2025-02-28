import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./config/database";
import userRoutes from "./routes/user.route";
import authRoutes from "./routes/auth.route";
import cloudinary from "./config/cloudinary";

dotenv.config();

const app = express();

connectDB();

app.use(express.json());
app.use("/api/users", userRoutes);
app.use("/api/auth", authRoutes);
app.get("/", (req, res) => {
  res.send("Hello World!");
});

export default app;
