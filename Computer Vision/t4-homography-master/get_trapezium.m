function t = get_trapezium()
    % t is a 4x2 matrix containing the x coordinates in the first column
    % Output points are always ordered SW, SE, NW, NE
    [x, y] = ginput(4);
    c = [sum(x)/4 sum(y)/4];
    [~, order_] = sort((sign(x-c(1))+sign(y-c(2)).*2+5)./2);
    t = [x(order_) y(order_)];