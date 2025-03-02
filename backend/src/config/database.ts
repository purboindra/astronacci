import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

const connectDB = async () => {
  try {
    console.log("Mongo uri", process.env.MONGO_URI);
    await mongoose.connect(process.env.MONGO_URI as string, {
      serverSelectionTimeoutMS: 3000,
      autoSelectFamily: false,
    });

    console.log("✅ MongoDB Connected Successfully");
  } catch (error) {
    console.error("❌ MongoDB Connection Error:", error);
    process.exit(1);
  }
};

export default connectDB;
