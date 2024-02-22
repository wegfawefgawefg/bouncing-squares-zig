const std = @import("std");
const graphics = @import("graphics");
const stdx = @import("stdx");
const fatal = stdx.fatal;
const build_options = @import("build_options");
const Vec2 = stdx.math.Vec2;
const vec2 = Vec2.init;
const builtin = @import("builtin");
const Color = graphics.Color;
const platform = @import("platform");

const helper = @import("helper.zig");
const log = stdx.log.scoped(.demo);

var app: helper.App = undefined;
var font_id: graphics.FontId = undefined;

pub fn main() !void {
    try app.init("Demo");
    defer app.deinit();

    app.runEventLoop(update);
}

fn update(delta_ms: f32) anyerror!void {
    const g = app.gctx;

    g.setFillColor(Color.Black);
    g.fillRect(0, 0, @floatFromInt(app.win.getWidth()), @floatFromInt(app.win.getHeight()));

    // Shapes.
    g.setFillColor(Color.Red);
    g.fillRect(60, 100, 300, 200);

    g.setLineWidth(8);
    g.setStrokeColor(Color.Red.darker());
    g.strokeRect(60, 100, 300, 200);

    g.translate(0, -120);
    g.rotateDeg(20);

    g.setFillColor(Color.Blue.withAlpha(150));
    g.fillRect(250, 200, 300, 200);
    g.resetTransform();

    // Gradients.
    g.setFillGradient(400, 500, Color.Red, 700, 700, Color.Blue);
    g.fillRect(400, 500, 300, 200);

    // Text.
    g.setFont(font_id, 26);
    g.setFillColor(Color.Orange);
    g.fillText(140, 10, "The quick brown fox 🦊 jumps over the lazy dog. 🐶");
    g.rotateDeg(45);
    g.setFont(font_id, 48);
    g.setFillColor(Color.SkyBlue);
    g.fillText(140, 10, "The quick brown fox 🦊 jumps over the lazy dog. 🐶");
    g.resetTransform();

    // More shapes.
    g.setFillColor(Color.Green);
    g.fillCircle(550, 150, 100);
    g.setFillColor(Color.Green.darker());
    g.fillCircleSectorDeg(550, 150, 100, 0, 120);

    g.setStrokeColor(Color.Yellow);
    g.strokeCircle(700, 200, 70);
    g.setStrokeColor(Color.Yellow.darker());
    g.strokeCircleArcDeg(700, 200, 70, 0, 120);

    g.setFillColor(Color.Purple);
    g.fillEllipse(850, 70, 80, 40);
    g.setFillColor(Color.Purple.lighter());
    g.fillEllipseSectorDeg(850, 70, 80, 40, 0, 240);
    g.setStrokeColor(Color.Brown);
    g.strokeEllipse(850, 70, 80, 40);
    g.setStrokeColor(Color.Brown.lighter());
    g.strokeEllipseArcDeg(850, 70, 80, 40, 0, 120);

    g.setFillColor(Color.Red);
    g.fillTriangle(850, 70, 800, 170, 900, 170);
    g.setFillColor(Color.Brown);
    g.fillConvexPolygon(&.{
        vec2(1000, 70),
        vec2(960, 120),
        vec2(950, 170),
        vec2(1000, 200),
        vec2(1050, 170),
        vec2(1040, 120),
    });
    const polygon = [_]Vec2{
        vec2(990, 140),
        vec2(1040, 65),
        vec2(1040, 115),
        vec2(1090, 40),
    };
    g.setFillColor(Color.DarkGray);
    try g.fillPolygon(&polygon);
    g.setStrokeColor(Color.Yellow);
    g.setLineWidth(3);
    g.strokePolygon(&polygon);

    g.setFillColor(Color.Blue.darker());
    g.fillRoundRect(70, 430, 200, 120, 30);
    g.setLineWidth(7);
    g.setStrokeColor(Color.Blue);
    g.strokeRoundRect(70, 430, 200, 120, 30);

    g.setStrokeColor(Color.Orange);
    g.setLineWidth(3);
    g.strokePoint(220, 220);
    g.strokeLine(240, 220, 300, 320);

    // Curves.
    g.resetTransform();
    g.setLineWidth(3);
    g.setStrokeColor(Color.Yellow);
    g.strokeQuadraticBezierCurve(0, 0, 200, 0, 200, 200);
    g.strokeCubicBezierCurve(0, 0, 200, 0, 0, 200, 200, 200);

    g.setFillColor(Color.Blue.lighter());
    const fps = 1000 / delta_ms;
    g.setFont(font_id, 26);
    g.fillTextFmt(1100, 10, "fps {d:.1}", .{fps});
}
