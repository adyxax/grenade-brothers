//----- Physics ---------------------------------------------------------------
pub const gravity: f64 = 9.807; // m/s²
pub const scale: f64 = 1.0 / 30; // 30 pixels == 1m

//----- Playground ------------------------------------------------------------
pub const side = enum(u1) {
    left,
    right,
};
pub const startingX = [2]u8{ 23, 160 - 23 - 16 };
pub const leftLimit = [2]u8{ 0, 81 };
pub const rightLimit = [2]u8{ 77, 159 };
