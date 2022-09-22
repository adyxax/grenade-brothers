const inputs = @import("inputs.zig");
const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

pub const Brother = struct {
    side: utils.side,
    score: u8,
    // position of the bottom left corner
    x: u8,
    y: f64,
    vy: f64,
    pub fn draw(self: Brother) void {
        var y = @floatToInt(u8, std.math.round(self.y));
        w4.DRAW_COLORS.* = 0x30;
        w4.blit(&brother, self.x, y - brother_height, brother_width, brother_height, brother_flags);
    }
    pub fn reset(self: *Brother, side: utils.side) void {
        self.side = side;
        self.score = 0;
    }
    pub fn resetRound(self: *Brother) void {
        self.x = utils.startingX[@enumToInt(self.side)];
        self.y = 160;
    }
    pub fn update(self: *Brother, gamepad: inputs.Gamepad) void {
        if (gamepad.held.left and self.x > utils.leftLimit[@enumToInt(self.side)])
            self.x -= 1;
        if (gamepad.held.right and self.x <= utils.rightLimit[@enumToInt(self.side)] - brother_width)
            self.x += 1;
        if (self.y < 160) { // jumping!
            self.vy += utils.gravity;
            self.y += self.vy * utils.frequency;
            if (self.y > 160)
                self.y = 160;
        } else if (gamepad.pressed.up) {
            self.vy = -200;
            self.y += self.vy * utils.frequency;
        }
    }
};

//----- Sprite ----------------------------------------------------------------
const brother_width = 16;
const brother_height = 32;
const brother_flags = 0; // BLIT_1BPP
const brother = [64]u8{ 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xfb, 0xdf, 0xfb, 0xdf, 0xfb, 0xdf, 0xfb, 0xdf, 0xf9, 0x9f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f, 0xf8, 0x1f };
