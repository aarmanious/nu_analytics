function ax_PositionCenti = nu_axPositionCenti(    TotalWidth      ,   TotalHeight     , ...
                                                leftMargins     ,   rightMargins    , ...
                                                lowerMargins    ,   upperMargins    , ...
                                                axesWidths      ,   axesHeights     )
% This function creates a matrix with the Position elements of stacked axis
% at equal spaces

nW  =   length( axesWidths  );
nH  =   length( axesHeights );

ax_PositionCenti     =   zeros( nW*nH  , 4 );

Wfree   =   TotalWidth  - ( leftMargins  + rightMargins + sum(axesWidths)   );
Hfree   =   TotalHeight - ( lowerMargins + upperMargins + sum(axesHeights)  );

if nW == 1
    Wgap    =   0;
else
    Wgap    =   Wfree / (nW-1);
end

if nH == 0
    Hgap    =   0;
else
    Hgap    =   Hfree / (nH-1);
end


ax_PositionCenti(1,1)    =   leftMargins;
ax_PositionCenti(1,2)    =   lowerMargins;

ax_PositionCenti(:,3)    =   repmat(    axesWidths'   , nH  ,   1 );
ax_PositionCenti(:,4)    =   repelem(   axesHeights'  , nW  ,   1 );

for i = 1:nH
    
    for j = 1:nW
        
        order   =   (i - 1) *  nW + j;
        ax_PositionCenti( order , 1 )    =   leftMargins     +   sum(axesWidths(1:j-1))  + ( j - 1 ) * Wgap;
        ax_PositionCenti( order , 2 )    =   lowerMargins    +   sum(axesHeights(1:i-1)) + ( i - 1 ) * Hgap ;
    
    end

end

end

