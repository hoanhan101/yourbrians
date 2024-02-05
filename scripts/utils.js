const fs = require("fs");
const DomParser = require("dom-parser");

const delay = (ms) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const blitmapEncode = (path) => {
  let colors = [];
  let data = fs.readFileSync(path, { encoding: "utf8" });
  var parser = new DomParser();
  let doc = parser.parseFromString(data, "image/svg+xml");
  let rectTags = doc.getElementsByTagName("rect");

  let tempColors = "";
  let tempBinary = "";
  let tempHex = "";

  if (rectTags.length == 0) {
    console.log("Invalid file");
    return;
  }

  for (const rect of rectTags) {
    const color = rect.getAttribute("fill");
    const colorString = color.toLowerCase().replace("#", "");

    if (!colors.includes(colorString)) {
      colors.push(colorString);

      if (colors.length > 4) {
        console.log("Exceed 4 colors");
        return;
      }
    }

    tempColors = colors.join("");

    if (colors[0] == colorString) {
      tempBinary += "00";
    } else if (colors[1] == colorString) {
      tempBinary += "01";
    } else if (colors[2] == colorString) {
      tempBinary += "10";
    } else if (colors[3] == colorString) {
      tempBinary += "11";
    }
  }

  tempHex = convertToHex(tempBinary);
  let payload = "0x" + tempColors + tempHex;
  if (payload.length != 538) {
    console.log("Invalid length");
  }

  return payload;
};

const binToHex = (number) => {
  let hex = parseInt(number, 2).toString(16);
  return hex.length == 1 ? "0" + hex : hex;
};

const convertToHex = (binary) => {
  let hexImage = "";
  for (let i = 0; i < binary.length; i += 8) {
    // Pack 4 colors into 1 byte
    hexImage += binToHex(
      binary[i] +
        binary[i + 1] +
        binary[i + 2] +
        binary[i + 3] +
        binary[i + 4] +
        binary[i + 5] +
        binary[i + 6] +
        binary[i + 7]
    );
  }

  return hexImage;
};

const randomColors = () => {
  let hex = Math.floor(Math.random() * 16777215).toString(16);
  hex = hex.padStart(6, "0");

  let color = hex.charAt(0) === "#" ? hex.substring(1, 7) : hex;
  let r = 255 - parseInt(color.substring(0, 2), 16);
  let g = 255 - parseInt(color.substring(2, 4), 16);
  let b = 255 - parseInt(color.substring(4, 6), 16);

  const inverted = ((1 << 24) | (r << 16) | (g << 8) | b).toString(16).slice(1);
  return [hex, inverted];
};

module.exports = {
  delay,
  blitmapEncode,
  randomColors,
};
