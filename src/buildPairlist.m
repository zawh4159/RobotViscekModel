function  [Idx] = buildPairlist(lattice_coords,robot_coords,Rcut,DomainBoundaries,PairlistMethod)
    
    CoordsA = lattice_coords';
    CoordsB = robot_coords';

    [a,b] = size(CoordsB);

    %search for neighbors within the cutoff Rcut
    % this method is okay if no periodic BC (for concave or convex)
    % if PairlistMethod == 1
    %     Idx = rangesearch(CoordsA,CoordsB,Rcut,'NSMethod','exhaustive');
    % 
    %     % if checking the list with itself remove self atom from the list
    %     if isequal(CoordsA,CoordsB)
    %         for ii = 1:length(Idx)
    %             Idx{ii}(1) = [];
    %         end
    %     end
    % end

    % needed if periodic BC (flat)
    %if PairlistMethod == 2
    Ldom = DomainBoundaries(2)-DomainBoundaries(1);
    for ii = 1:length(CoordsA) %loop through lattice coords

            xi = CoordsA(ii,1); 
            yi = CoordsA(ii,2);
    
            intvector = zeros(length(CoordsA),1);
 
            for jj = 1:a %loop through robot coords
        
                    xj = CoordsB(jj,1); 
                    yj = CoordsB(jj,2);

                    dx = abs(xi-xj);
                    dy = abs(yi-yj);

                    if PairlistMethod == 2
                        if dx > Ldom/2
                            dx = Ldom-dx;
                        end
                        if dy > Ldom/2
                            dy = Ldom-dy;
                        end
                    end
                    D(ii,jj) = norm([dx dy]);

                    if D(ii,jj) < Rcut
                        intvector(jj) = true;
                    end

            end
    
            Idx{ii} = find(intvector==true);
    end

    Idx = Idx';

end