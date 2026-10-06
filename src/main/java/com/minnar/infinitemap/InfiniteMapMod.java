package com.minnar.infinitemap;

import net.fabricmc.api.ClientModInitializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class InfiniteMapMod implements ClientModInitializer {
    public static final String MOD_ID = "infinitemap";
    public static final Logger LOGGER = LoggerFactory.getLogger(MOD_ID);

    @Override
    public void onInitializeClient() {
        LOGGER.info("Infinite Map мод инициализирован.");
    }
}
