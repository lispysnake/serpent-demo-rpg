/*
 * This file is part of serpent.
 *
 * Copyright © 2019-2020 Lispy Snake, Ltd.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

import serpent;
import serpent.graphics.sprite;
import serpent.tiled;

import std.path : buildPath;
import std.getopt;
import std.stdio;

/* Simple no-op app */
class MyApp : serpent.App
{

    Scene scene;
    box2f viewBounds;
    box2f worldBounds;

    final void keyReleased(KeyboardEvent e)
    {
        context.quit();
    }

    final void mouseMoved(MouseEvent e)
    {
        scene.camera.position = vec3f(e.x, e.y, 0.0f);
        scene.camera.clamp(worldBounds, viewBounds);
    }

    final override bool bootstrap(View!ReadWrite view)
    {
        scene = new Scene("default");
        context.display.addScene(scene);
        scene.addCamera(new OrthographicCamera());
        scene.camera.position(vec3f(0.0f, 400.0f, 0.0f));

        context.input.keyReleased.connect(&keyReleased);
        context.input.mouseMoved.connect(&mouseMoved);

        auto mapView = view.createEntity();
        auto mapComponent = MapComponent();
        auto transform = TransformComponent();
        auto tmxPath = buildPath("assets", "Pipoya RPG Tileset 32x32",
                "SampleMap", "samplemap.tmx");
        mapComponent.map = TMXParser.loadTMX(tmxPath);
        view.addComponent(mapView, mapComponent);
        view.addComponent(mapView, transform);

        viewBounds = rectanglef(0.0f, 0.0f, 1366.0f, 768.0f);
        worldBounds = rectanglef(0.0f, 0.0f, mapComponent.map.tileWidth * mapComponent.map.width,
                mapComponent.map.tileHeight * mapComponent.map.height);
        return true;
    }
}

/* Main entry */
int main(string[] args)
{
    bool vulkan = false;
    bool fullscreen = false;
    bool debugMode = false;
    bool disableVsync = false;
    auto argp = getopt(args, std.getopt.config.bundling, "v|vulkan",
            "Use Vulkan instead of OpenGL", &vulkan, "f|fullscreen",
            "Start in fullscreen mode", &fullscreen, "d|debug", "Enable debug mode",
            &debugMode, "n|no-vsync", "Disable VSync", &disableVsync);

    if (argp.helpWanted)
    {
        defaultGetoptPrinter("serpent demonstration\n", argp.options);
        return 0;
    }

    /* Context is essential to *all* Serpent usage. */
    auto context = new Context();
    context.display.title("#serpent RPG demo").size(1366, 768);
    context.display.logicalSize(960, 540);
    context.display.backgroundColor = 0x0f;

    if (vulkan)
    {
        context.display.title = context.display.title ~ " [Vulkan]";
    }
    else
    {
        context.display.title = context.display.title ~ " [OpenGL]";
    }

    /* We want OpenGL or Vulkan? */
    if (vulkan)
    {
        writeln("Requesting Vulkan display mode");
        context.display.pipeline.driverType = DriverType.Vulkan;
    }
    else
    {
        writeln("Requesting OpenGL display mode");
        context.display.pipeline.driverType = DriverType.OpenGL;
    }

    if (fullscreen)
    {
        writeln("Starting in fullscreen mode");
        context.display.fullscreen = true;
    }

    if (debugMode)
    {
        writeln("Starting in debug mode");
        context.display.pipeline.debugMode = true;
    }

    if (disableVsync)
    {
        writeln("Disabling vsync");
    }

    /* TODO: Remove need for casts! */
    import serpent.graphics.pipeline.bgfx;

    auto pipe = cast(BgfxPipeline) context.display.pipeline;
    pipe.addRenderer(new MapRenderer());
    pipe.addRenderer(new SpriteRenderer());

    return context.run(new MyApp);
}
