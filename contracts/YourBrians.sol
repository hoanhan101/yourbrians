// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Your Brian in your favorite color
 * By hoanh.eth
 */

import "@0xsequence/sstore2/contracts/SSTORE2.sol";
import "solady/src/utils/LibString.sol";
import "solady/src/utils/Base64.sol";

import {ERC721A} from "erc721a/contracts/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

struct Brian {
    string body;
    string background;
}

struct SVGCursor {
    uint8 x;
    uint8 y;
    string color1;
    string color2;
    string color3;
    string color4;
}

contract YourBrians is ERC721A, Ownable {
    uint256 public immutable supply;

    address private _encodedArt;
    Brian[] private brians;

    error MintClose();
    error MintOut();
    error InvalidLength();
    error InvalidToken();

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply
    ) ERC721A(_name, _symbol) {
        supply = _supply;
    }

    function uploadArt(bytes memory _art) external onlyOwner {
        if (_art.length != 268) revert InvalidLength();
        _encodedArt = SSTORE2.write(_art);
    }

    function airdrop(string[2] memory _colors, address _to) external onlyOwner {
        Brian memory brian;
        brian.body = _colors[0];
        brian.background = _colors[1];
        brians.push(brian);

        _mint(_to, 1);
    }

    function getBodyColor(uint256 _id) public view returns (string memory) {
        if (!_exists(_id)) revert InvalidToken();

        Brian memory brian = brians[_id];
        return brian.body;
    }

    function getBackgroundColor(
        uint256 _id
    ) public view returns (string memory) {
        if (!_exists(_id)) revert InvalidToken();

        Brian memory brian = brians[_id];
        return brian.background;
    }

    function getSVG(uint256 _id) public view returns (string memory) {
        if (!_exists(_id)) revert InvalidToken();

        Brian memory brian = brians[_id];
        return string(_buildArt(brian));
    }

    function tokenURI(
        uint256 _id
    ) public view virtual override(ERC721A) returns (string memory metadata) {
        if (!_exists(_id)) revert InvalidToken();

        Brian memory brian = brians[_id];
        bytes memory payload;

        payload = abi.encodePacked(
            '{"name": "YourBrian #',
            LibString.toString(_id),
            '", "description":"',
            "Your Brian in your favorite color",
            '","image":"data:image/svg+xml;base64,',
            Base64.encode(_buildArt(brian)),
            '",',
            '"attributes": [',
            _buildMetadata("body", brian.body),
            ",",
            _buildMetadata("background", brian.background),
            "]}"
        );

        return string(abi.encodePacked("data:application/json,", payload));
    }

    function _buildMetadata(
        string memory key,
        string memory value
    ) internal pure returns (string memory trait) {
        return
            string.concat('{"trait_type":"', key, '","value": "', value, '"}');
    }

    // Leverage Blitmap's encoding technique (0x8d04a8c79ceb0889bdd12acdf3fa9d207ed3ff63)
    function _buildArt(Brian memory brian) private view returns (bytes memory) {
        string
            memory svgString = '<svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" version="1.1">';

        string[32] memory lookup = [
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20",
            "21",
            "22",
            "23",
            "24",
            "25",
            "26",
            "27",
            "28",
            "29",
            "30",
            "31"
        ];

        bytes memory data = SSTORE2.read(_encodedArt);
        string[4] memory colors = [
            string(abi.encodePacked("#", brian.background)),
            string(abi.encodePacked("#", "000000")),
            string(abi.encodePacked("#", brian.body)),
            string(abi.encodePacked("#", "ffffff"))
        ];
        SVGCursor memory pos;
        string[8] memory p;
        for (uint256 i = 12; i < 268; i += 8) {
            pos.color1 = colors[_colorIndex(data[i], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i], 0, 1)];
            p[0] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 1], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 1], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 1], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 1], 0, 1)];
            p[1] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 2], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 2], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 2], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 2], 0, 1)];
            p[2] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 3], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 3], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 3], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 3], 0, 1)];
            p[3] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 4], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 4], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 4], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 4], 0, 1)];
            p[4] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 5], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 5], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 5], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 5], 0, 1)];
            p[5] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 6], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 6], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 6], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 6], 0, 1)];
            p[6] = pixel4(lookup, pos);
            pos.x += 4;

            pos.color1 = colors[_colorIndex(data[i + 7], 6, 7)];
            pos.color2 = colors[_colorIndex(data[i + 7], 4, 5)];
            pos.color3 = colors[_colorIndex(data[i + 7], 2, 3)];
            pos.color4 = colors[_colorIndex(data[i + 7], 0, 1)];
            p[7] = pixel4(lookup, pos);
            pos.x += 4;

            svgString = string(
                abi.encodePacked(
                    svgString,
                    p[0],
                    p[1],
                    p[2],
                    p[3],
                    p[4],
                    p[5],
                    p[6],
                    p[7]
                )
            );

            if (pos.x >= 32) {
                pos.x = 0;
                pos.y += 1;
            }
        }

        return abi.encodePacked(svgString, "</svg>");
    }

    function _byteToHexString(bytes1 b) internal pure returns (string memory) {
        return _uintToHexString(_byteToUint(b));
    }

    function _uintToHexString(uint256 a) internal pure returns (string memory) {
        uint256 count = 0;
        uint256 b = a;
        while (b != 0) {
            count++;
            b /= 16;
        }
        bytes memory res = new bytes(count);
        for (uint256 i = 0; i < count; ++i) {
            b = a % 16;
            res[count - i - 1] = _uintToHexDigit(uint8(b));
            a /= 16;
        }

        string memory str = string(res);
        if (bytes(str).length == 0) {
            return "00";
        } else if (bytes(str).length == 1) {
            return string(abi.encodePacked("0", str));
        }
        return str;
    }

    function _byteToUint(bytes1 b) internal pure returns (uint256) {
        return uint256(uint8(b));
    }

    function _uintToHexDigit(uint8 d) internal pure returns (bytes1) {
        if (0 <= d && d <= 9) {
            return bytes1(uint8(bytes1("0")) + d);
        } else if (10 <= uint8(d) && uint8(d) <= 15) {
            return bytes1(uint8(bytes1("a")) + d - 10);
        }
        revert();
    }

    function _bitTest(bytes1 aByte, uint8 index) internal pure returns (bool) {
        return (uint8(aByte) >> index) & 1 == 1;
    }

    function _colorIndex(
        bytes1 aByte,
        uint8 index1,
        uint8 index2
    ) internal pure returns (uint256) {
        if (_bitTest(aByte, index2) && _bitTest(aByte, index1)) {
            return 3;
        } else if (_bitTest(aByte, index2) && !_bitTest(aByte, index1)) {
            return 2;
        } else if (!_bitTest(aByte, index2) && _bitTest(aByte, index1)) {
            return 1;
        }
        return 0;
    }

    function pixel4(
        string[32] memory lookup,
        SVGCursor memory pos
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<rect fill="',
                    pos.color1,
                    '" x="',
                    lookup[pos.x],
                    '" y="',
                    lookup[pos.y],
                    '" width="1.5" height="1.5" />',
                    '<rect fill="',
                    pos.color2,
                    '" x="',
                    lookup[pos.x + 1],
                    '" y="',
                    lookup[pos.y],
                    '" width="1.5" height="1.5" />',
                    string(
                        abi.encodePacked(
                            '<rect fill="',
                            pos.color3,
                            '" x="',
                            lookup[pos.x + 2],
                            '" y="',
                            lookup[pos.y],
                            '" width="1.5" height="1.5" />',
                            '<rect fill="',
                            pos.color4,
                            '" x="',
                            lookup[pos.x + 3],
                            '" y="',
                            lookup[pos.y],
                            '" width="1.5" height="1.5" />'
                        )
                    )
                )
            );
    }
}
