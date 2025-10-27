-- export_tags_to_spritesheets.lua
-- Exports each tag as a separate spritesheet

local spr = app.activeSprite
if not spr then
  return app.alert("No active sprite to export.")
end

-- Ask user where to save
local dlg = Dialog("Export Tags as Spritesheets")
dlg:file{
  id="basepath",
  label="Save to",
  title="Choose output directory",
  open=false,
  save=false
}
dlg:button{id="ok", text="Export", focus=true}
dlg:button{id="cancel", text="Cancel"}
dlg:show()

local data = dlg.data
if not data.ok then return end
if not data.basepath or data.basepath == "" then
  return app.alert("No output path specified.")
end

local basepath = data.basepath
local baseName = app.fs.fileTitle(spr.filename)
local outputDir = app.fs.filePath(basepath)
if outputDir == "" then outputDir = "." end

app.transaction(function()
  for i, tag in ipairs(spr.tags) do
    local tagName = tag.name
    local outputName = string.format("%s_%s.png", baseName, tagName)
    local outputPath = app.fs.joinPath(outputDir, outputName)

    app.command.ExportSpriteSheet{
      ui=false,
      askOverwrite=false,
      type=SpriteSheetType.HORIZONTAL,
      textureFilename=outputPath,
      dataFilename=app.fs.joinPath(outputDir, baseName .. "_" .. tagName .. ".json"),
      tag=tagName,
      borderPadding=0,
      shapePadding=0,
      innerPadding=0,
      trim=false,
      extrude=false,
      openGenerated=false
    }

    print("Exported tag:", tagName, "→", outputPath)
  end
end)

app.alert("✅ Export complete! All tags saved as spritesheets.")
