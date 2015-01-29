function is_point_in_polygon (point, polygon)
	local count = 0
	for i=1,#polygon,2 do
		if point[1] <= math.min(polygon[i], polygon[(i + 2) % #polygon]) then
			local y1 = polygon[i + 1]
			local y2
			if i + 3 > #polygon then
				y2 = polygon[2]
			else
				y2 = polygon[i + 3]
			end
			local y3 = point[2]
			if y1 < y2 then
				if y3 >= y1 and y3 <= y2 then
					count = count + 1
				end
			else
				if y3 <= y1 and y3 >= y2 then
					count = count + 1
				end
			end
		end
	end
	return count % 2 ~= 0
end


function is_polygon_in_polygon (polygon1, polygon2)
	for i=1,#polygon1,2 do
		if is_point_in_polygon({polygon1[i], polygon1[i + 1]}, polygon2) then
			return true
		end
	end

	return false
end
