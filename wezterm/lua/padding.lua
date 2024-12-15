local M = {}

M.readjust_font_size = function(window, pane)
	local window_dims = window:get_dimensions()
	local pane_dims = pane:get_dimensions()

	local config_overrides = {}
	local initial_font_size = 12 -- Set to your desired font size
	config_overrides.font_size = initial_font_size

	local iteration_count = 0
	local max_iterations = 5 -- How many time to try
	local tolerance = 3 -- How many pixels at the bottom are tolerated

	-- Calculate the initial difference between window and pane heights
	local current_diff = window_dims.pixel_height - pane_dims.pixel_height
	local min_diff = math.abs(current_diff)
	local best_font_size = initial_font_size

	-- Loop to adjust font size until the difference is within tolerance or max iterations reached
	while current_diff > tolerance and iteration_count < max_iterations do
		-- Increment the font size slightly
		config_overrides.font_size = config_overrides.font_size + 0.5
		window:set_config_overrides(config_overrides)

		-- Update dimensions after changing font size
		window_dims = window:get_dimensions()
		pane_dims = pane:get_dimensions()
		current_diff = window_dims.pixel_height - pane_dims.pixel_height

		-- Check if the current difference is the smallest seen so far
		local abs_diff = math.abs(current_diff)
		if abs_diff < min_diff then
			min_diff = abs_diff
			best_font_size = config_overrides.font_size
		end

		iteration_count = iteration_count + 1
	end

	-- If no acceptable difference was found, set the font size to the best one encountered
	if current_diff > tolerance then
		config_overrides.font_size = best_font_size
		window:set_config_overrides(config_overrides)
	end
end

return M
