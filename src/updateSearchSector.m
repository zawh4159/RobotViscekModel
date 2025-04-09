function [search_sector] = updateSearchSector(search_sector,NumSearchSectors)
    
    %this is temporary
    search_sector = randi(NumSearchSectors,[1 length(search_sector)]);

end