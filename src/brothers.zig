const std = @import("std");
const spoon = @import("spoon");

pub const Side = enum(u1) {
    left,
    right,
};

const startingX = [2]f64{ 15, 60 };
const colors = [2]spoon.Attribute.Colour{ .blue, .red };

pub const Brother = struct {
    side: Side,
    x: f64,
    y: f64,
    dx: f64,
    dy: f64,
    pub fn reset(self: *Brother, side: ?Side) void {
        if (side) |s| {
            self.side = s;
        }
        self.x = startingX[@enumToInt(self.side)];
        self.y = 17;
        self.dx = 0;
        self.dy = 0;
    }
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
};

const brother =
    \\█   █
    \\█ █ █
    \\█████
    \\█████
    \\█   █
    \\█   █
;
