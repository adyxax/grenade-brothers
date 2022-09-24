const std = @import("std");
const utils = @import("utils.zig");
const w4 = @import("wasm4.zig");

pub const Ball = struct {
    // position of the top left corner
    x: f64,
    y: f64,
    vx: f64,
    vy: f64,
    pub fn draw(self: Ball) void {
        var y = @floatToInt(u8, std.math.round(self.y));
        var x = @floatToInt(u8, std.math.round(self.x));
        w4.DRAW_COLORS.* = 0x2400;
        w4.blit(&ball, x, y, ball_width, ball_height, ball_flags);
    }
    pub fn resetRound(self: *Ball, side: utils.side) void {
        self.x = @intToFloat(f64, utils.startingX[@enumToInt(side)] + 4);
        self.y = 160 - 32 - 8;
        self.vx = 0;
        self.vy = -250;
    }
    pub fn update(self: *Ball) void {
        self.vy += utils.gravity;
        self.x += self.vx * utils.frequency;
        self.y += self.vy * utils.frequency;
        // collisions handling
        if (self.x < 0) { // left wall
            self.vx = -self.vx * utils.bounce;
            self.x = 0;
        }
        if (self.x >= 160 - ball_width) { // right wall
            self.vx = -self.vx * utils.bounce;
            self.x = 160 - ball_width - 1;
        }
        if (self.y < 0) { // ceiling
            self.vy = -self.vy * utils.bounce;
            self.y = 0;
        }
        if (self.y >= 160 - ball_height) { // floor
            self.vy = 0;
            self.y = 160 - ball_height;
        }
        // Net collision
        var x1: f64 = 78 - ball_width;
        var x2: f64 = 82;
        var y1: f64 = 100 - ball_height;
        var y2: f64 = 160;
        if (self.x >= x1 and self.x < x2 and self.y >= y1 and self.y < y2) {
            if (self.vx > 0) {
                self.x = x1;
            } else {
                self.x = x2;
            }
            self.vx = -self.vx;
        }
        // TODO collision with top of the net?
    }
};

//----- Sprite ----------------------------------------------------------------
const ball_width = 8;
const ball_height = 8;
const ball_flags = 1; // BLIT_2BPP
const ball = [16]u8{ 0x1a, 0xa4, 0x6f, 0xf9, 0xbf, 0xae, 0xbf, 0xae, 0xbf, 0xfe, 0xbf, 0xfe, 0x6f, 0xf9, 0x1a, 0xa4 };
