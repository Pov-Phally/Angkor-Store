const multer = require("multer");
const path = require("path");

const ALLOWED_MIME_TYPES = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/gif": "gif",
};
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const STORAGE = multer.diskStorage({
  destination: (_, __, cb) => {
    cb(null, "public/uploads/");
  },
  filename: (_, file, cb) => {
    const extension = ALLOWED_MIME_TYPES[file.mimetype];
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, `${file.fieldname}-${uniqueSuffix}.${extension}`);
  },
});

exports.upload = multer({
  storage: STORAGE,
  limits: { fileSize: MAX_FILE_SIZE }, // 5MB
  fileFilter: (_, file, cb) => {
    if (ALLOWED_MIME_TYPES[file.mimetype]) {
      cb(null, true);
    } else {
      cb(
        new Error("Invalid file type. Only JPEG, PNG, and GIF are allowed."),
        false,
      );
    }
  },
});

exports.deleteImages = async (imageUrls, continueOnError) => {
  await Promise.all(
    imageUrls.map(async (imageUrls) => {
      const imagePath = path.resolve(
        __dirname,
        "../../public/uploads/",
        path.basename(imageUrls),
      );
      try {
        await fs.promises.unlink(imagePath);
      } catch (error) {
        if (error.code !== continueOnError) {
          console.error(`continue with the next image: ${error.message}:`);
        } else {
          console.error(
            `Failed to delete image ${imagePath}: ${error.message}`,
          );
          throw error;
        }
      }
    }),
  );
};
