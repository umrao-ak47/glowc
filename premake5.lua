workspace "Glowc"
architecture "X64"

configurations
{
	"Debug",
	"Release"
}

outputdir = "%{cfg.buildcfg}_%{cfg.system}_%{cfg.architecture}"
IncludeDir = {}
IncludeDir["GLFW"] = "external/GLFW/include"
IncludeDir["glad"] = "external/glad/include"
IncludeDir["glm"] = "external/glm"


project "GLFW"
	location "external/GLFW"
	kind "StaticLib"
	language "C"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		'%{prj.location}/include/GLFW/glfw3.h',
		'%{prj.location}/include/GLFW/glfw3native.h',
		'%{prj.location}/src/context.c',
		'%{prj.location}/src/init.c',
		'%{prj.location}/src/input.c',
		'%{prj.location}/src/monitor.c',
		'%{prj.location}/src/vulkan.c',
		'%{prj.location}/src/window.c'
	}

	filter "system:windows"
		systemversion "latest"

		files
		{
			'%{prj.location}/src/win32_init.c',
			'%{prj.location}/src/win32_joystick.c',
			'%{prj.location}/src/win32_monitor.c',
			'%{prj.location}/src/win32_time.c',
			'%{prj.location}/src/win32_thread.c',
			'%{prj.location}/src/win32_window.c',
			'%{prj.location}/src/wgl_context.c',
			'%{prj.location}/src/egl_context.c',
			'%{prj.location}/src/osmesa_context.c'
		}

		defines
		{
			"_GLFW_WIN32",
			"_CRT_SECURE_NO_WARNINGS"
		}

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"

project "glad"
	location "external/glad"
	kind "StaticLib"
	language "C"
	staticruntime "On"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		'%{prj.location}/include/glad/glad.h',
		'%{prj.location}/include/KHR/khrplatform.h',
		'%{prj.location}/src/glad.c'
	}

	includedirs
	{
		"%{prj.location}/include/glad/"
	}

	filter "system:windows"
		systemversion "latest"
	
	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"

project "glowc"
	location "glowc"
	kind "SharedLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%/{prj.name}")

	files
	{
		"%{prj.name}/include/%{prj.name}/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/include/%{prj.name}"
	}

	links
	{
		"opengl32.lib"
	}

	filter "system:windows"
		systemversion "latest"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"


project "Sandbox"
	location "SandBox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"glowc/include/glowc",
		"%{IncludeDir.glm}",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.glad}"
	}

	links
	{
		"GLFW",
		"glad",
		"glowc"
	}

	filter "system:windows"
		systemversion "latest"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"