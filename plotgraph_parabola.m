function plotgraph_parabola(x, y, Adj)
%%
% Network visualization using parabolic edges
% Date Created: 06/30/2016, for vortical network visualization
% Date Modified: 07/15/2022, generalized
% By Muralikrishnan Gopalakrishnan Meena, ORNL (gopalakrishm@ornl.gov)
%%
% plotgraph_flow(axs, x, y, Adj, Xlim, Ylim)
% Function to visualize the network of a vortex system in a flow field
% representation
% x         : x coordinates of vertices
% y         : y coordinates of vertices
% Adj       : adjacency matrix
% Xlim      : x limits of the domain
% Ylim      : y limits of the domain

%% Load network details of current snapshot
pts = length(x);
n_cor = zeros(pts,2);     % coordinates of nodes
for j = 1:pts
    n_cor(j,:) = [x(j),y(j)];
end
Adj_nor = Adj/max(max(Adj));
Node_weight = (sum(Adj_nor,1)' + sum(Adj_nor,2));

%% Plot nodes
for j = 1:pts
    plot(n_cor(j,1), n_cor(j,2),'o', 'Color', 'k',... color(2,:),...%'k',...
        'MarkerFaceColor','k','MarkerSize', 10) %30 * abs(log10(Node_weight(j))),'linewidth',1.7)
end

%% Plot edges
for j = 1:pts
    if j/2 == 0 % change parabola orientation for odd and even starting points
        dir = -1;
    else
        dir = 1;
    end
    for k = j+1:pts
        edge_color = Adj(j,k);
        trans_color = Adj_nor(j,k);
        x_pts = [n_cor(j,1), n_cor(k,1)];
        y_pts = [n_cor(j,2), n_cor(k,2)];
        % create parabolic lines between points
        % y = ax^2 + bx + c: y(1) and y(2) - 2 eqns.
        % y' = 2ax + b = slope of parabola: y'(1) - 1 eqn.
        % take y'(1), y(1) and y(2) - solve 3 equations to obtain a,b,c
        A_p = [2*x_pts(1),    1,          0;
            x_pts(1)^2,    x_pts(1),   1;
            x_pts(2)^2,    x_pts(2),   1];
        B_p = [ dir*1.0       ; % slope of parabola changes sign alternatively
            y_pts(1);
            y_pts(2)];
        C_p = A_p\B_p;
        a = C_p(1); b = C_p(2); c = C_p(3); % coefficients of parabola equation
        yp = @(xp) a*xp.^2 + b*xp + c;
        x_co = linspace(x_pts(1),x_pts(2));
        y_co = yp(x_co);
        y_co(end) = NaN; % to remove line between first and last point
        patch(x_co, y_co, log10( edge_color*ones(1,length(x_co)) ), ...
            'EdgeColor', 'flat', 'FaceColor','none','LineWidth',2.2,...
            'EdgeAlpha',trans_color)
        dir = -dir;
    end
    
end
axis equal
% set(gca,'XLim',Xlim,'YLim',Ylim)
box on,axis off

% Give each one its own colormap
colormap('parula')
set(gcf, 'color', 'w');

end     % end function