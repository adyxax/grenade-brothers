const std = @import("std");
const w4 = @import("wasm4.zig");

// This packed struct matches the buttons definitions in wasm4.zig
// so that a bitCast can give us named fields
pub const Buttons = packed struct {
    x: bool = false,
    y: bool = false,
    _: u2 = 0,
    left: bool = false,
    right: bool = false,
    up: bool = false,
    down: bool = false,
};

pub const Gamepad = struct {
    held: Buttons = .{},
    pressed: Buttons = .{},
    released: Buttons = .{},

    pub fn reset(self: *Gamepad) void {
        self.held = @bitCast(Buttons, @bitCast(u8, self.held) ^ @bitCast(u8, self.held));
        self.pressed = @bitCast(Buttons, @bitCast(u8, self.pressed) ^ @bitCast(u8, self.pressed));
        self.released = @bitCast(Buttons, @bitCast(u8, self.released) ^ @bitCast(u8, self.released));
    }
    pub fn update(self: *Gamepad, buttons: u8) void {
        var previous = @bitCast(u8, self.held);
        self.held = @bitCast(Buttons, buttons);
        self.pressed = @bitCast(Buttons, buttons & (buttons ^ previous));
        self.released = @bitCast(Buttons, previous & (buttons ^ previous));
    }
};
