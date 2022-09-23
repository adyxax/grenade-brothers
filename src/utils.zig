//----- Physics ---------------------------------------------------------------
pub const bounce: f64 = 0.7; // energy dispersion when bouncing
pub const gravity: f64 = 9.807; // m/s²
pub const scale: f64 = 1.0 / 30.0; // 30 pixels == 1m
pub const frequency: f64 = 1.0 / 60.0; // 60 fps

//----- Playground ------------------------------------------------------------
pub const side = enum(u1) {
    left,
    right,
};
pub const startingX = [2]u8{ 23, 160 - 23 - 16 };
pub const leftLimit = [2]u8{ 0, 81 };
pub const rightLimit = [2]u8{ 77, 159 };
