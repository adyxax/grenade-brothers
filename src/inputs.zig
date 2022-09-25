const std = @import("std");
const w4 = @import("wasm4.zig");

// This packed struct matches the buttons definitions in wasm4.zig
// so that a bitCast can give us named fields
pub const Buttons = packed struct {
    x: bool = false,
    y: bool = false,
    _: u2,
    left: bool = false,
    right: bool = false,
    up: bool = false,
    down: bool = false,
};

pub const Gamepad = struct {
    held: Buttons = .{},
    pressed: Buttons = .{},
    released: Buttons = .{},

    pub fn update(self: *Gamepad, buttons: u8) void {
        var previous = @bitCast(u8, self.held);
        self.held = @bitCast(Buttons, buttons);
        self.pressed = @bitCast(Buttons, buttons & (buttons ^ previous));
        self.released = @bitCast(Buttons, previous & (buttons ^ previous));
    }
};
