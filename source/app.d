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

/* Simple no-op app */
class MyApp : serpent.App
{

    final override bool bootstrap(View!ReadWrite view)
    {
        auto sprite = view.createEntity();
        return true;
    }
}

/* Main entry */
void main()
{
    auto context = new serpent.Context();
    context.display.pipeline.debugMode = true;
    context.display.pipeline.driverType = DriverType.OpenGL;
    auto sc = new Scene("default");
    auto cm = new OrthographicCamera();
    context.display.addScene(sc);
    sc.addCamera(cm);
    context.run(new MyApp);
}
