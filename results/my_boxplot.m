function out = my_boxplot(in,folder)

%in(11,:) = mean(in);

s = 2*std(in);

m = mean(in);

mean_box_height = 0.0025;
mean_box_width = 0.5;
cla reset;
for index = 1:size(in,2)
    X = [index - mean_box_width/2, ...
                        index - mean_box_width/2, ...
                        index + mean_box_width/2, ...
                        index + mean_box_width/2];
     Y =  [m(index) - mean_box_height/2, ...
                           m(index) + mean_box_height/2, ...
                           m(index) + mean_box_height/2, ...
                           m(index) - mean_box_height/2];              
    m_poly = polyshape(X,Y);
    plot(m_poly,'FaceColor','red','FaceAlpha',0.7, 'LineStyle', 'none')
    colormap hot
    hold on
    
end


s_box_width = 0.1;

for index = 1:size(in,2)
    s_box_height = s(index);
    X = [index - s_box_width/2, ...
                        index - s_box_width/2, ...
                        index + s_box_width/2, ...
                        index + s_box_width/2];
     Y =  [m(index) - s_box_height/2, ...
                           m(index) + s_box_height/2, ...
                           m(index) + s_box_height/2, ...
                           m(index) - s_box_height/2];              
    m_poly = polyshape(X,Y);
    plot(m_poly,'FaceColor','black','FaceAlpha',0.2,'LineStyle', 'none')
end
for index = 1:size(in,2)
    Y = in(:,index)';
    X = index*ones(1,size(Y,2));
    
    %scatter(X,Y,'k.');
end

ylim([0.2 1])

end