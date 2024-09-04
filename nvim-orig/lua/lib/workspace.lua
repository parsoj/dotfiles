local lfs = require("lfs")

-- Function to recursively search for .workspace file
function find_workspace_file(start_path, max_depth)
  -- Set default max_depth if not provided
  max_depth = max_depth or 50
  -- Helper function to check if .workspace file exists in a given directory
  local function has_workspace_file(path)
    for file in lfs.dir(path) do
      if file == ".workspace" then
        return true
      end
    end
    return false
  end
  -- Recursive search function
  local function search_upward(path, depth)
    if depth > max_depth then
      return nil
    end
    if has_workspace_file(path) then
      return path
    else
      local parent_path = path:match("(.*/)")
      if parent_path then
        return search_upward(parent_path:sub(1, -2), depth + 1)
      else
        return nil
      end
    end
  end
  -- Start the search from the given path
  return search_upward(start_path, 0)
end

-- Example usage:
local start_path = lfs.currentdir()
local workspace_path = find_workspace_file(start_path)
if workspace_path then
  print("Found .workspace file in: " .. workspace_path)
else
  print(".workspace file not found within the specified depth.")
end
