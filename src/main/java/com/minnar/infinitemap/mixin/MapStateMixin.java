package com.minnar.infinitemap.mixin;

import net.minecraft.item.map.MapState;
import net.minecraft.entity.player.PlayerEntity;
import net.minecraft.item.ItemStack;
import net.minecraft.world.World;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(MapState.class)
public abstract class MapStateMixin {
    private static final int EXTENDED_RADIUS = 1000;
    private static final int CHUNK_LOAD_STEP = 16;
    private int tickCounter = 0;
    private int spiralOffset = 0;

    @Inject(method = "update", at = @At("HEAD"))
    private void onUpdate(PlayerEntity player, ItemStack map, CallbackInfo ci) {
        tickCounter++;

        if (player != null) {
            MapState self = (MapState) (Object) this;
            self.xCenter = player.getBlockPos().getX();
            self.zCenter = player.getBlockPos().getZ();
            self.scale = 0;
        }

        if (tickCounter % 20 == 0) {
            preloadChunksAroundPlayer(player);
        }
    }

    private void preloadChunksAroundPlayer(PlayerEntity player) {
        World world = player.world;
        if (world == null) return;

        int playerX = player.getBlockPos().getX();
        int playerZ = player.getBlockPos().getZ();

        for (int r = spiralOffset; r < EXTENDED_RADIUS; r += CHUNK_LOAD_STEP) {
            int chunkX = (playerX >> 4) + (r >> 4);
            int chunkZ = playerZ >> 4;
            world.getChunk(chunkX, chunkZ);

            chunkX = playerX >> 4;
            chunkZ = (playerZ >> 4) + (r >> 4);
            world.getChunk(chunkX, chunkZ);

            chunkX = (playerX >> 4) + (r >> 4);
            chunkZ = (playerZ >> 4) + (r >> 4);
            world.getChunk(chunkX, chunkZ);
        }

        spiralOffset = (spiralOffset + CHUNK_LOAD_STEP) % EXTENDED_RADIUS;
    }
}
