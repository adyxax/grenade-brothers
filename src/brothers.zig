const ball = @import("ball.zig");
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
    pub fn collide(self: Brother, b: *ball.Ball) void {
        // compute the collision box
        const x1: f64 = @intToFloat(f64, self.x) - ball.ball_width;
        const x2: f64 = @intToFloat(f64, self.x) + brother_width;
        const y1: f64 = self.y - brother_height - ball.ball_height;
        const y2: f64 = self.y - brother_height;
        if (b.x >= x1 and b.x < x2 and b.y >= y1 and b.y < y2) {
            // horizontal adjustement
            b.vx += (b.x - @intToFloat(f64, self.x) - 4) * 10;
            // vertical adjustment
            if (b.vy > 0) {
                b.vy = -b.vy * utils.bounce;
                if (self.vy < 0)
                    b.vy *= 2;
            }
            b.vy -= 22;
            b.y = y1;
        }
    }
    pub fn draw(self: Brother) void {
        var y = @floatToInt(u8, std.math.round(self.y));
        w4.DRAW_COLORS.* = 0x30;
        w4.blit(&brother, self.x, y - brother_height, brother_width, brother_height, brother_flags);
        var buf: [3]u8 = undefined;
        w4.DRAW_COLORS.* = 0x32;
        _ = std.fmt.formatIntBuf(&buf, self.score, 10, .lower, .{ .width = 3 });
        if (self.side == .left) {
            w4.text(buf[0..], 0, 0);
        } else {
            w4.text(buf[0..], 136, 0);
        }
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
        } else if (gamepad.pressed.up or gamepad.pressed.x) {
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
