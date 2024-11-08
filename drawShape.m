function drawShape(xang, yang, scale, theta, rotatev, dotson, normalson)
global GL
global win
glPushMatrix;
glRotatef(theta,rotatev(1),rotatev(2),rotatev(3));
glRotatef(yang,0,1,0);
glRotatef(xang,1,0,0);
a=scale;
glScalef(a,a,a);
glColor4f(0.8,0.8,0.8,1.0);
moglmorpher('render');
glPopMatrix;
return;