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

/* Simple no-op app */
class MyApp : serpent.App
{

    Scene scene;

    final void keyReleased(KeyboardEvent e)
    {
        context.quit();
    }

    final override bool bootstrap(View!ReadWrite view)
    {
        scene = new Scene("default");
        context.display.addScene(scene);
        scene.addCamera(new OrthographicCamera());
        scene.camera.position(vec3f(0.0f, 400.0f, 0.0f));

        context.input.keyReleased.connect(&keyReleased);

        auto mapView = view.createEntity();
        auto mapComponent = MapComponent();
        auto transform = TransformComponent();
        auto tmxPath = buildPath("assets", "Pipoya RPG Tileset 32x32", "SampleMap", "samplemap.tmx");
        mapComponent.map = TMXParser.loadTMX(tmxPath);
        view.addComponent(mapView, mapComponent);
        view.addComponent(mapView, transform);
        return true;
    }
}

/* Main entry */
void main()
{
    auto context = new serpent.Context();
    context.display.pipeline.driverType = DriverType.Vulkan;
    context.display.size(1366, 768);
    context.display.logicalSize(960, 540);
    context.display.fullscreen = true;
    context.display.title = "#serpent RPG Demo";

    /* TODO: Remove need for casts! */
    import serpent.graphics.pipeline.bgfx;

    auto pipe = cast(BgfxPipeline) context.display.pipeline;
    pipe.addRenderer(new MapRenderer());
    pipe.addRenderer(new SpriteRenderer());

    context.run(new MyApp);
}
