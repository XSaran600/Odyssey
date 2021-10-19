// Cristian Pop - https://boxophobic.com/

namespace TheVegetationEngine
{
    public enum TextureSizes
    {
        _4 = 4,
        _16 = 16,
        _32 = 32,
        _64 = 64,
        _128 = 128,
        _256 = 256,
        _512 = 512,
        _1024 = 1024,
        _2048 = 2048,
    }

    public enum RenderMode
    {
        Baked = 10,
        Realtime = 20,
    }

    public enum ElementMode
    {
        Shared = -10,
        Colors = 20,
        ColorsHDR = 40,
        Healthiness = 50,
        Overlay = 60,
        Wetness = 80,
        Size = 100,
        Leaves = 120,
        //MotionFlow,
        MotionInteraction = 140,
    }

    public enum ToggleMode
    {
        Off = 0,
        On = 1,
    }

    public enum LinkMode
    {
        FirstToSecond = 0,
        SecondToFirst = 1,
    }
}