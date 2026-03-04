<!DOCTYPE html>
<!--YPwVN17XLuMh3zctibovR-->
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <title>BookHub - Your Gateway to Endless Stories</title>
    <meta name="description" content="Discover thousands of books across every genre. Shop for bestsellers, classics, and hidden gems with BookHub."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="books,bookstore,ebook,bestsellers,fiction,non-fiction"/>
    <link rel="stylesheet" href="assets/css/tailwind.css">
</head>
<body class="font-sans antialiased">
<div class="min-h-screen bg-background flex items-center justify-center px-4 py-8">
    <div class="w-full max-w-4xl">
        <div data-slot="card" class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-8 sm:p-10">
            <div class="flex items-center gap-2 mb-8">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-book-open w-6 h-6 text-primary" aria-hidden="true">
                    <path d="M12 7v14"></path>
                    <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                </svg>
                <h1 class="text-2xl font-bold text-primary">BookHub</h1>
            </div>
            <h2 class="text-3xl font-bold text-foreground mb-2">Create Account</h2>
            <p class="text-muted-foreground mb-8">Join our reading community</p>
            <form action="signup" method="post" class="space-y-6">
                <div class="grid grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-semibold text-foreground mb-2">First Name</label>
                        <div class="relative">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user absolute left-3 top-3 w-5 h-5 text-muted-foreground" aria-hidden="true">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <input type="text" placeholder="John" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="firstName" value=""/>
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-foreground mb-2">Last Name</label>
                        <div class="relative">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user absolute left-3 top-3 w-5 h-5 text-muted-foreground" aria-hidden="true">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <input type="text" placeholder="Doe" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="lastName" value=""/>
                        </div>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-foreground mb-2">Username</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-user absolute left-3 top-3 w-5 h-5 text-muted-foreground" aria-hidden="true">
                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <input type="text" placeholder="johndoe123" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="username" value=""/>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-foreground mb-2">Email Address</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-mail absolute left-3 top-3 w-5 h-5 text-muted-foreground" aria-hidden="true">
                            <path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path>
                            <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                        </svg>
                        <input type="email" placeholder="johndoe123@example.com" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="email" value=""/>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-foreground mb-2">Birth Date</label>
                    <div class="relative">
                        <input type="date" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="birthDate" value=""/>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-foreground mb-2">Job</label>
                    <div class="relative">
                        <input type="text" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="job" value=""/>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-foreground mb-2">Password</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-lock absolute left-3 top-3 w-5 h-5 text-muted-foreground" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" placeholder="Min. 8 characters" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="password" value=""/>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-foreground mb-2">Confirm Password</label>
                    <div class="relative">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-lock absolute left-3 top-3 w-5 h-5 text-muted-foreground" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" placeholder="Confirm password" class="w-full pl-10 pr-4 py-2 rounded-lg border border-border bg-background text-foreground placeholder-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary" name="confirmPassword" value=""/>
                    </div>
                </div>
                <button data-slot="button" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm transition-all disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg:not([class*=&#x27;size-&#x27;])]:size-4 shrink-0 [&amp;_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive h-9 px-4 has-[&gt;svg]:px-3 w-full bg-primary hover:bg-primary/90 text-background py-2.5 font-semibold" type="submit">Create Account</button>
            </form>
            <div class="mt-8 text-center space-y-4">
                <p class="text-muted-foreground">
                    Already have an account?
                    <!-- -->
                    <a class="text-primary hover:underline font-semibold" href="login">Login</a>
                </p>
                <a class="block text-primary hover:underline text-sm" href="home">Back to Home</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
