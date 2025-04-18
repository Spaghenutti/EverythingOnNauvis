--------------------------------------------------------------------------------
-- Fixes map generation for resources
--------------------------------------------------------------------------------
local terrain = require("map-generation.terrain")

local util =
{
  table = {}
}

function util.spritesheets_to_pictures(spritesheets)
  local pictures = {}
  for _, spritesheet in pairs(spritesheets) do
    for i = 1, spritesheet.frame_count or 1, 1 do
      table.insert(pictures, util.sprite_load(spritesheet.path,
        {
          frame_index = i - 1,
          scale = spritesheet.scale or 0.5,
          dice_y = spritesheet.dice_y
        })
      )
    end
  end
  return pictures
end

--------------------------------------------------------------------------------
-- MARK: Fix Nauvis resources
--------------------------------------------------------------------------------

-- Remove resources spawning on ammonia ocean
terrain.mask_resource_territory("iron-ore", "resource")
terrain.mask_resource_territory("copper-ore", "resource")
terrain.mask_resource_territory("stone", "resource")
terrain.mask_resource_territory("coal", "resource")
terrain.mask_resource_territory("uranium-ore", "resource")
terrain.mask_resource_territory("crude-oil", "resource")

--------------------------------------------------------------------------------
-- MARK: Remove Aquilo resources to from Aquilo -- Dunno why i have to do this only for this planet...
--------------------------------------------------------------------------------

data.raw["noise-expression"]["aquilo_crude_oil_spots"].expression = "0"  --  This removes aquilo islands for crude oil
data.raw.planet["aquilo"].map_gen_settings.autoplace_controls = {nil}

--------------------------------------------------------------------------------
-- MARK: Add Fulgora resources to Nauvis
--------------------------------------------------------------------------------

-- Add holmium as ore
data.raw.planet["nauvis"].map_gen_settings.autoplace_controls["holmium-ore"] = {}
data.raw.planet["nauvis"].map_gen_settings.autoplace_settings.entity.settings["holmium-ore"] = {}
terrain.mask_resource_territory("holmium-ore", "resource")

--------------------------------------------------------------------------------
-- MARK: Gleba
--------------------------------------------------------------------------------

data.raw["autoplace-control"]["gleba_plants"].localised_description = {"autoplace-control-names.gleba_plants_description"}

--------------------------------------------------------------------------------
-- MARK: Add Vulcanus resources to Nauvis
--------------------------------------------------------------------------------

-- property_expression_names
data.raw.planet["nauvis"].map_gen_settings.property_expression_names["entity:sulfuric-acid-geyser:probability"] = "vulcanus_sulfuric_acid_geyser_probability"
data.raw.planet["nauvis"].map_gen_settings.property_expression_names["entity:sulfuric-acid-geyser:richness"] = "vulcanus_sulfuric_acid_geyser_richness"

-- Add calcite to volcanic rocks
table.insert(data.raw["simple-entity"]["big-volcanic-rock"].minable.results, {type = "item", name = "calcite", amount_min = 2, amount_max = 8})
table.insert(data.raw["simple-entity"]["huge-volcanic-rock"].minable.results, {type = "item", name = "calcite", amount_min = 3, amount_max = 15})

-- Set vulcane as resource
data.raw["autoplace-control"]["vulcanus_volcanism"].order = "z-volcanism"
data.raw["autoplace-control"]["vulcanus_volcanism"].localised_description = {"autoplace-control-names.vulcanus_volcanism_description"}
data.raw["autoplace-control"]["vulcanus_volcanism"].category = "resource"

-- reorder autoplace controls
data.raw["autoplace-control"]["sulfuric_acid_geyser"].order = "b-z"

-- Add resources to nauvis
data.raw.planet["nauvis"].map_gen_settings.autoplace_settings.entity.settings["calcite"] = {}
data.raw.planet["nauvis"].map_gen_settings.autoplace_settings.entity.settings["sulfuric-acid-geyser"] = {}
data.raw.planet["nauvis"].map_gen_settings.autoplace_settings.entity.settings["tungsten-ore"] = {}

-- autoplace_controls
data.raw.planet["nauvis"].map_gen_settings.autoplace_controls["sulfuric_acid_geyser"] = {}

-- Mask resources from ammonia ocean
terrain.mask_resource_territory("calcite", "resource")
terrain.mask_resource_territory("tungsten-ore", "resource")

-- START: Fix Resource spawning
data.raw.resource["calcite"].autoplace.has_starting_area_placement = false -- Does nothing but noise expression vulcanus_starting_calcite removes starter spot
data.raw["noise-expression"]["vulcanus_starting_calcite"].expression = "-inf"
data.raw["noise-expression"]["vulcanus_calcite_probability"].expression = "eon_mask_off_ammonia_ocean((control:calcite:size > 0) * (1000 * ((0.5 + vulcanus_calcite_region) * random_penalty_between(0.9, 1, 1) - 1)))"

data.raw.resource["sulfuric-acid-geyser"].autoplace.has_starting_area_placement = false -- Does nothing but noise expression vulcanus_starting_sulfur removes starter spot
data.raw["noise-expression"]["vulcanus_sulfuric_acid_geyser_probability"].expression = "(control:sulfuric_acid_geyser:size > 0) * (0.005 * ((vulcanus_sulfuric_acid_region_patchy > 0) + 2 * eon_updated_volcanic_folds))"
data.raw["noise-expression"]["vulcanus_starting_sulfur"].expression = "-inf"

data.raw.resource["tungsten-ore"].autoplace.has_starting_area_placement = false -- Does nothing but noise expression vulcanus_starting_tungsten removes starter spot
data.raw["noise-expression"]["vulcanus_tungsten_ore_probability"].expression = "eon_mask_off_ammonia_ocean((control:tungsten_ore:size > 0) * (1000 * ((0.7 + vulcanus_tungsten_ore_region) * random_penalty_between(0.9, 1, 1) - 1)))"
data.raw["noise-expression"]["vulcanus_starting_tungsten"].expression = "-inf"
-- END: Fix Resource spawning
