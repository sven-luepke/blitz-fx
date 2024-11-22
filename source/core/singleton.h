#pragma once

namespace w3
{
template <typename T>
class Singleton
{
public:
	Singleton(const Singleton&) = delete;
	Singleton(const Singleton&&) = delete;
	Singleton operator=(const Singleton&) = delete;
	Singleton operator=(const Singleton&&) = delete;

	static T& Get()
	{
		static T instance;
		return instance;
	}
protected:
	Singleton() = default;
	~Singleton() = default;
};
}
