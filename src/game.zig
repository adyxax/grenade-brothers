const std = @import("std");
const spoon = @import("spoon");

const brothers = @import("brothers.zig");
const playfield = @import("playfield.zig");

pub const Game = struct {
    brothers: [2]brothers.Brother = undefined,
    character: ?brothers.Side = undefined,
    pub fn draw(self: Game, rc: *spoon.Term.RenderContext) !void {
        try playfield.draw(rc);
        try self.brothers[0].draw(rc);
        try self.brothers[1].draw(rc);
    }
    pub fn reset(self: *Game) void {
        self.resetRound();
    }
    pub fn resetRound(self: *Game) void {
        self.brothers[0].reset(brothers.Side.left);
        self.brothers[1].reset(brothers.Side.right);
    }
};
