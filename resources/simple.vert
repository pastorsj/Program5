#version 330

uniform mat4 P;
uniform mat4 C;
uniform mat4 mT;
uniform mat4 mR;
uniform mat4 M;
uniform mat4 N;
uniform mat4 L;
uniform vec4 lightPos;
uniform vec4 camPos; 
uniform int shadingMode;

in vec3 pos;
in vec3 colorIn;

smooth out vec4 smoothColor;

vec4 justColor()
{
    return vec4(colorIn, 1);
}

vec4 gouraud()
{
    return abs(vec4(1) - vec4(colorIn, 1));
}

vec4 phong()
{
    vec3 ambientIntensity = 0.1 * colorIn;
    vec4 lightNormal = L * lightPos;
    vec4 surfaceNormal = vec4(colorIn * 2 - vec3(1,1,1), 1); //Reversing the scaling operation
    float dot1 = dot(lightNormal, surfaceNormal);
    //Change
    float distance = sqrt(pow(pos.x-colorIn.x, 2) + pow(pos.y-colorIn.y, 2) + pow(pos.z-colorIn.z, 2));
    vec3 diffuseIntensity = (1 / distance) * dot1 * colorIn;
    vec4 viewVector = C * camPos;
    float dot2 = dot(viewVector, surfaceNormal);
    vec4 reflectionVector = (2 * dot2 * surfaceNormal) - viewVector;
    float dot3 = dot(reflectionVector, viewVector);
    vec3 specularIntensity = colorIn * pow(dot3, 10);
    return vec4(ambientIntensity + diffuseIntensity + specularIntensity, 1);
}

void main()
{
    //TODO add gouraud and phong shading support
    
	vec4 pos = vec4(pos, 1);
	gl_Position = P*M*pos;
    
    if(shadingMode == 0)
        smoothColor = justColor();
    else if (shadingMode == 1)
        smoothColor = gouraud();
    else
        smoothColor = phong();
}
