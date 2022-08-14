const std = @import("std");
const spoon = @import("spoon");

const game = @import("game.zig");

var term: spoon.Term = undefined;
var done: bool = false;

//----- Game State -----------------------------------------------------------
var gs: game.Game = undefined;

//----- Main -----------------------------------------------------------------
pub fn main() !void {
    try term.init();
    defer term.deinit();

    std.os.sigaction(std.os.SIG.WINCH, &std.os.Sigaction{
        .handler = .{ .handler = handleSigWinch },
        .mask = std.os.empty_sigset,
        .flags = 0,
    }, null);

    var fds: [1]std.os.pollfd = undefined;
    fds[0] = .{
        .fd = term.tty.handle,
        .events = std.os.POLL.IN,
        .revents = undefined,
    };

    try term.uncook(.{});
    defer term.cook() catch {};

    try term.fetchSize();
    try term.setWindowTitle("Grenade Brothers", .{});

    gs.reset(.left);
    try renderAll();

    var buf: [16]u8 = undefined;
    while (!done) {
        // TODO We need to measure how long it took before a key was hit so that we can adjust the timeout on the next loop
        // otherwise we will get inconsistent ticks for movement steps
        const timeout = try std.os.poll(&fds, @floatToInt(u64, 1000 / 60.0));

        if (timeout > 0) { // if timeout if not 0 then some fds we are polling have events for us
            const read = try term.readInput(&buf);
            var it = spoon.inputParser(buf[0..read]);
            while (it.next()) |in| {
                if (in.eqlDescription("escape") or in.eqlDescription("q")) {
                    done = true;
                    break;
                } else if (in.eqlDescription("arrow-left") or in.eqlDescription("a")) {
                    gs.moveLeft();
                } else if (in.eqlDescription("arrow-right") or in.eqlDescription("d")) {
                    gs.moveRight();
                }
            }
        } else {
            gs.step();
        }
        try renderAll();
    }
}

fn renderAll() !void {
    var rc = try term.getRenderContext();
    defer rc.done() catch {};

    try rc.clear();

    if (term.width < 80 or term.width < 24) {
        try rc.setAttribute(.{ .fg = .red, .bold = true });
        try rc.writeAllWrapping("Terminal too small!");
        return;
    }

    try gs.draw(&rc);
}

fn handleSigWinch(_: c_int) callconv(.C) void {
    term.fetchSize() catch {};
    renderAll() catch {};
}

/// Custom panic handler, so that we can try to cook the terminal on a crash,
/// as otherwise all messages will be mangled.
pub fn panic(msg: []const u8, trace: ?*std.builtin.StackTrace) noreturn {
    @setCold(true);
    term.cook() catch {};
    std.builtin.default_panic(msg, trace);
}
