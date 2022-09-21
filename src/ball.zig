const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

pub const Ball = struct {
    x: f64,
    y: f64,
    dx: f64,
    dy: f64,
    pub fn draw(self: Ball) void {
        var y = @floatToInt(u8, std.math.round(self.y));
        var x = @floatToInt(u8, std.math.round(self.x));
        w4.DRAW_COLORS.* = 0x4321;
        w4.blit(&ball, x, y, ball_width, ball_height, ball_flags);
    }
    pub fn resetRound(self: *Ball, side: utils.side) void {
        self.x = @intToFloat(f64, utils.startingX[@enumToInt(side)] + 4);
        self.y = 160 - 32 - 8;
        self.dx = 0;
        self.dy = 0;
    }
};

//----- Sprite ----------------------------------------------------------------
const ball_width = 8;
const ball_height = 8;
const ball_flags = 1; // BLIT_2BPP
const ball = [16]u8{ 0x1a, 0xa4, 0x6f, 0xf9, 0xbf, 0xae, 0xbf, 0xae, 0xbf, 0xfe, 0xbf, 0xfe, 0x6f, 0xf9, 0x1a, 0xa4 };
