const std = @import("std");
const spoon = @import("spoon");

pub const Side = enum(u1) {
    left,
    right,
};

const startingX = [2]f64{ 15, 60 };
const colors = [2]spoon.Attribute.Colour{ .blue, .red };
const leftLimit = [2]f64{ 1, 40 };
const rightLimit = [2]f64{ 33, 74 }; // (38, 79) minus a brother's width

pub const Brother = struct {
    side: Side,
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
    pub fn moveLeft(self: *Brother) void {
        self.dx -= 5 / (1000 / 60.0);
        self.moveDuration = 24;
    }
    pub fn moveRight(self: *Brother) void {
        self.dx += 5 / (1000 / 60.0);
        self.moveDuration = 24;
    }
    pub fn step(self: *Brother) void {
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
    }
    pub fn reset(self: *Brother, side: ?Side) void {
        if (side) |s| {
            self.side = s;
        }
        self.x = startingX[@enumToInt(self.side)];
        self.y = 17;
        self.dx = 0;
        self.dy = 0;
        self.moveDuration = 0;
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
