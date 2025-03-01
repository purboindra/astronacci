import app from "./app";

const PORT = process.env.PORT || 3000;

app.listen(parseInt(PORT.toString()), "0.0.0.0", () => {
  console.log(`Server is running at http://0.0.0.0:3000`);
});
