const std = @import("std");
const spoon = @import("spoon");

const ball = @import("ball.zig");

pub const Side = enum(u1) {
    left,
    right,
};

const startingX = [2]f64{ 15, 60 };
const colors = [2]spoon.Attribute.Colour{ .blue, .red };
const leftLimit = [2]f64{ 1, 41 };
const rightLimit = [2]f64{ 34, 74 }; // (38, 79) minus a brother's width

pub const Brother = struct {
    side: Side,
    score: u8,
    x: f64,
    y: f64,
    dx: f64,
    dy: f64,
    moveDuration: u64,
    pub fn draw(self: Brother, rc: *spoon.Term.RenderContext) !void {
        try rc.setAttribute(.{ .fg = colors[@enumToInt(self.side)] });
        var iter = std.mem.split(u8, brother, "\n");
        var y = @floatToInt(usize, std.math.round(self.y));
        var x = @floatToInt(usize, std.math.round(self.x));
        while (iter.next()) |line| : (y += 1) {
            try rc.moveCursorTo(y, x);
            _ = try rc.buffer.writer().write(line);
        }
    }
    pub fn moveJump(self: *Brother) void {
        if (self.dy == 0) { // no double jumps! TODO allow kicks off the wall
            self.dy -= 4 / (1000 / 60.0);
        }
    }
    pub fn moveLeft(self: *Brother) void {
        self.dx -= 5 / (1000 / 60.0);
        self.moveDuration = 24;
    }
    pub fn moveRight(self: *Brother) void {
        self.dx += 5 / (1000 / 60.0);
        self.moveDuration = 24;
    }
    pub fn reset(self: *Brother, side: Side) void {
        self.side = side;
        self.score = 0;
    }
    pub fn resetRound(self: *Brother) void {
        self.x = startingX[@enumToInt(self.side)];
        self.y = 17;
        self.dx = 0;
        self.dy = 0;
        self.moveDuration = 0;
    }
    pub fn step(self: *Brother, b: *ball.Ball) void {
        // Horizontal movement
        const x = self.x + self.dx;
        const ll = leftLimit[@enumToInt(self.side)];
        const rl = rightLimit[@enumToInt(self.side)];
        if (x < ll) {
            self.x = ll;
            self.dx = 0;
            self.moveDuration = 0;
        } else if (x > rl) {
            self.x = rl;
            self.dx = 0;
            self.moveDuration = 0;
        } else {
            self.x = x;
            if (self.moveDuration > 0) {
                self.moveDuration -= 1;
                if (self.moveDuration == 0) {
                    self.dx = 0;
                }
            }
        }
        // Vertical movement
        const y = self.y + self.dy;
        if (y < 12) { // jumping
            self.y = 12;
            self.dy = -self.dy;
        } else if (y > 17) { // falling
            self.y = 17;
            self.dy = 0;
        } else {
            self.y = y;
        }
        // Check for ball collisions
        if (b.y >= y and b.y <= y + 2 and b.x >= x and b.x < x + 5) {
            if (b.dy > 0) {
                b.dy = -b.dy / 1.5;
            }
            b.dx = b.dx / 2.0;
            var strength: f64 = 1;
            if (b.dx > 0 and self.dx < 0)
                strength *= 2; // moving in opposite directions
            if (y < 12) { // jumping
                strength *= 2;
            }
            if (b.x < x + 1) {
                b.dx -= strength * 4 / (1000 / 60.0);
            } else if (b.x < x + 2) {
                b.dx -= strength * 2 / (1000 / 60.0);
            } else if (b.x < x + 3) {
                var modifier: f64 = 1;
                if (self.side == .left) modifier = -1;
                b.dx += modifier * strength * 2 / (1000 / 60.0);
            } else if (b.x < x + 4) {
                b.dx += strength * 2 / (1000 / 60.0);
            } else {
                b.dx += strength * 4 / (1000 / 60.0);
            }
            b.dy = b.dy * strength - 0.04;
        }
    }
};

const brother =
    \\█   █
    \\█ █ █
    \\█████
    \\█████
    \\█   █
    \\█   █
;
