func = @(h,efold,x,x0) h*exp(-(x-x0).^2/efold);
x = linspace(-15,15,1000);
h = 5;
x0 = 0;
efold = [1 2 5];

clf;
for i = 1:length(efold)
% yyaxis left
y = func(h,efold(i),x,x0);

plot(x,y,'k')
delta_s = max(gradient(y));
% yyaxis right
% plot(x,gradient(y),'r');
% str = sprintf('Delta s = %.3f',max(gradient(y)));

str2 = {'E-fold: ','Delta s: '};

elength = h/exp(1);
x1 = find(y>elength,1,'first');
x2 = find(y>elength,1,'last');
efold_length = x(x2)-x(x1);
fprintf('i = %i \t elength = %.2f \t del s = %.2f\n',i,efold_length,delta_s)
% legend({sprintf('E-fold: %i')})
hold on;
grid on;

drawnow  
end
% set(gca,'units','centimeters')
% 
% set(gca,'xlimmode','manual','ylimmode','manual')
% 
% axpos = get(gca,'position');
% 
% % set(gca,'position',[axpos(1:2) abs(diff(xlim)) abs(diff(ylim))])
% set(gca,'position',[[8 10] abs(diff(xlim)) abs(diff(ylim))])
% print
% end
% 
% print(gcf,'-dpng','-r0','hill.png')
% winopen('hill.png')