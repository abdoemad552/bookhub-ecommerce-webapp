<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html lang="en">
<head>
    <meta charSet="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5, user-scalable=yes"/>
    <meta name="description" content="Manage your BookHub profile, orders, addresses, credit, and account security."/>
    <meta name="generator" content="BookHub"/>
    <meta name="keywords" content="bookhub,profile,orders,addresses,credit,security"/>
    <title>BookHub - My Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tailwind.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
</head>
<body class="font-google-sans antialiased">
<div class="min-h-screen bg-background">
    <jsp:include page="../common/header.jsp"/>
    <main class="max-w-7xl mx-auto px-4 py-12">
        <h1 class="text-4xl font-bold text-foreground mb-8">My Account</h1>

        <c:if test="${not empty requestScope.profile_success_message}">
            <div class="mb-6 rounded-xl border border-emerald-500/30 bg-emerald-500/10 px-4 py-3 text-sm font-medium text-emerald-400">
                ${requestScope.profile_success_message}
            </div>
        </c:if>

        <c:if test="${not empty requestScope.profile_error_message}">
            <div class="mb-6 rounded-xl border border-red-500/30 bg-red-500/10 px-4 py-3 text-sm font-medium text-red-400">
                ${requestScope.profile_error_message}
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-1">
                <div class="bg-card text-card-foreground flex flex-col gap-6 rounded-xl border shadow-sm p-6">
                    <div class="flex items-center gap-4 mb-2 pb-6 border-b border-border">
                        <div class="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 text-primary" aria-hidden="true">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </div>
                        <div class="min-w-0">
                            <c:choose>
                                <c:when test="${not empty requestScope.profileUser.firstName or not empty requestScope.profileUser.lastName}">
                                    <p class="font-semibold text-foreground truncate">${requestScope.profileUser.firstName} ${requestScope.profileUser.lastName}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="font-semibold text-foreground truncate">${requestScope.profileUser.username}</p>
                                </c:otherwise>
                            </c:choose>
                            <p class="text-sm text-muted-foreground truncate">${requestScope.profileUser.email}</p>
                        </div>
                    </div>
                    <nav class="space-y-2">
                        <button type="button" data-tab="profile-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors bg-primary text-background">Profile</button>
                        <button type="button" data-tab="orders-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Orders</button>
                        <button type="button" data-tab="wishlist-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Wishlist</button>
                        <button type="button" data-tab="addresses-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Addresses</button>
                        <button type="button" data-tab="credit-manage-info" class="profile-tab w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors hover:bg-accent text-foreground">Credit Management</button>
                    </nav>
                </div>
            </div>

            <div class="lg:col-span-3">
                <div id="profile-info" class="profile-panel bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <div class="flex flex-col gap-2 mb-6">
                        <h2 class="text-2xl font-bold text-foreground">Profile Information</h2>
                    </div>

                    <form id="profile-update-form" action="${pageContext.request.contextPath}/profile" method="post" class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">First Name</label>
                                <input type="text" name="firstName" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="${requestScope.profileUser.firstName}" required/>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Last Name</label>
                                <input type="text" name="lastName" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="${requestScope.profileUser.lastName}" required/>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Username</label>
                                <input type="text" class="w-full px-4 py-2 rounded-lg border border-border bg-muted text-muted-foreground focus:outline-none" value="${requestScope.profileUser.username}" readonly/>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Email Address</label>
                                <input type="email" class="w-full px-4 py-2 rounded-lg border border-border bg-muted text-muted-foreground focus:outline-none" value="${requestScope.profileUser.email}" readonly/>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Job Title</label>
                                <input type="text" name="job" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="${requestScope.profileUser.job}"/>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Birth Date</label>
                                <input type="date" name="birthDate" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="${requestScope.profileUser.birthDate}"/>
                            </div>
                        </div>

                        <label class="flex items-center gap-3 rounded-lg border border-border bg-background px-4 py-3 cursor-pointer">
                            <input type="checkbox" name="emailNotifications" class="h-4 w-4 rounded border-border text-primary focus:ring-primary" <c:if test="${requestScope.profileUser.emailNotifications}">checked</c:if>/>
                            <div>
                                <p class="text-sm font-semibold text-foreground">Email Notifications</p>
                                <p class="text-sm text-muted-foreground">Allow BookHub to send account and order emails.</p>
                            </div>
                        </label>

                        <div class="rounded-xl border border-border bg-background p-5 space-y-4">
                            <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                                <div>
                                    <h3 class="text-lg font-semibold text-foreground">Interests</h3>
                                    <p class="text-sm text-muted-foreground mt-1">Choose the categories you want BookHub to remember for your account.</p>
                                </div>
                                <div id="profile-selected-interests-count" class="inline-flex items-center rounded-full border border-primary/20 bg-primary/10 px-3 py-1 text-sm font-medium text-primary">
                                    0 selected
                                </div>
                            </div>

                            <div id="profile-selected-interests" class="flex flex-wrap gap-2"></div>

                            <c:choose>
                                <c:when test="${empty requestScope.profileAvailableCategories}">
                                    <div class="rounded-lg border border-dashed border-border px-4 py-6 text-sm text-center text-muted-foreground">
                                        No categories are available right now.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-3">
                                        <c:forEach items="${requestScope.profileAvailableCategories}" var="category">
                                            <label data-interest-option class="flex items-start gap-3 rounded-xl border border-border bg-card px-4 py-3 cursor-pointer transition-colors hover:border-primary/30 hover:bg-primary/5">
                                                <input
                                                        type="checkbox"
                                                        name="interestIds"
                                                        value="${category.id}"
                                                        data-interest-name="${category.name}"
                                                        class="profile-interest-checkbox mt-1 h-4 w-4 rounded border-border text-primary focus:ring-primary"
                                                        <c:if test="${requestScope.profileInterestSelections[category.id]}">checked</c:if>
                                                />
                                                <div class="min-w-0">
                                                    <p class="text-sm font-semibold text-foreground">${category.name}</p>
                                                    <c:if test="${not empty category.description}">
                                                        <p class="mt-1 text-sm text-muted-foreground line-clamp-2">${category.description}</p>
                                                    </c:if>
                                                </div>
                                            </label>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="rounded-xl border border-border bg-background p-5 space-y-4">
                            <div>
                                <h3 class="text-lg font-semibold text-foreground">Change Password</h3>
                                <p class="text-sm text-muted-foreground mt-1">Leave these blank if you do not want to change your password. New passwords must be at least 8 characters long.</p>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">Current Password</label>
                                    <input id="currentPassword" type="password" name="currentPassword" autocomplete="current-password" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"/>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">New Password</label>
                                    <input id="newPassword" type="password" name="newPassword" autocomplete="new-password" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"/>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">Retype New Password</label>
                                    <input id="confirmNewPassword" type="password" name="confirmNewPassword" autocomplete="new-password" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary"/>
                                </div>
                            </div>

                            <p id="password-validation-message" class="text-sm text-muted-foreground"></p>
                        </div>

                        <button type="submit" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">Save Changes</button>
                    </form>
                </div>

                <div id="orders-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <h2 class="text-2xl font-bold text-foreground mb-6">Order History</h2>

                    <c:choose>
                        <c:when test="${empty requestScope.profileOrders}">
                            <div class="rounded-lg border border-dashed border-border px-6 py-8 text-center text-muted-foreground">
                                You have not placed any orders yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-3">
                                <c:forEach items="${requestScope.profileOrders}" var="order">
                                    <a href="${pageContext.request.contextPath}/order-confirmation?orderId=${order.orderId}" class="block rounded-xl border border-border bg-background px-5 py-4 shadow-sm transition-transform hover:-translate-y-0.5 hover:border-primary/40 hover:shadow-md">
                                        <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                                            <div class="space-y-1">
                                                <p class="text-xl font-semibold text-foreground">${order.orderCode}</p>
                                                <p class="text-sm text-muted-foreground">${order.createdAt}</p>
                                            </div>

                                            <div class="flex items-center justify-between gap-3 md:justify-end">
                                                <div class="text-right">
                                                    <p class="text-xl font-semibold text-foreground">${order.totalPrice}</p>
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus.prettyName eq 'Delivered'}"><p class="text-sm font-semibold text-emerald-500">${order.orderStatus.prettyName}</p></c:when>
                                                        <c:when test="${order.orderStatus.prettyName eq 'Canceled'}"><p class="text-sm font-semibold text-red-500">${order.orderStatus.prettyName}</p></c:when>
                                                        <c:otherwise><p class="text-sm font-semibold text-amber-500">${order.orderStatus.prettyName}</p></c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="w-10 h-10 rounded-lg border border-border bg-card flex items-center justify-center text-foreground">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                                                        <path d="m9 18 6-6-6-6"></path>
                                                    </svg>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="wishlist-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <div class="flex flex-col gap-2 mb-6">
                        <h2 class="text-2xl font-bold text-foreground">Wishlist</h2>
                        <p class="text-sm text-muted-foreground">Your saved books appear here.</p>
                    </div>

                    <c:choose>
                        <c:when test="${empty requestScope.profileWishlistBooks}">
                            <div class="rounded-lg border border-dashed border-border px-6 py-8 text-center text-muted-foreground">
                                Your wishlist is empty.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-1 xl:grid-cols-2 gap-4">
                                <c:forEach items="${requestScope.profileWishlistBooks}" var="book">
                                    <div onclick="if (event.target.closest('[data-remove-wishlist-button]')) { return; } window.location.href = '${pageContext.request.contextPath}/books/${book.id}'" class="bg-card text-card-foreground rounded-xl border shadow-sm overflow-hidden hover:shadow-lg hover:scale-95 cursor-pointer flex flex-row transition-all duration-150 ease-in-out w-full">
                                        <div class="w-24 sm:w-28 md:w-32 shrink-0">
                                            <c:choose>
                                                <c:when test="${not empty book.coverPicUrl}">
                                                    <img src="${book.coverPicUrl}" alt="${book.title}" class="w-full h-full object-cover" />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="w-full h-full bg-[#eef2ec] flex items-center justify-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#b39d95" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" class="w-10 h-10" aria-hidden="true">
                                                            <path d="M12 7v14"></path>
                                                            <path d="M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z"></path>
                                                        </svg>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="p-3 md:p-4 flex flex-col flex-1 select-none">
                                            <div class="flex-1">
                                                <div class="flex justify-between items-center mb-1">
                                                    <h3 class="font-semibold text-foreground line-clamp-2 text-sm md:text-base">${book.title}</h3>
                                                    <c:if test="${book.stockQuantity le 0}">
                                                        <span class="text-sm ml-2 bg-red-200 text-red-950 rounded-lg px-2 py-1">Out of stock</span>
                                                    </c:if>
                                                </div>
                                                <p class="text-xs md:text-sm text-muted-foreground mb-2">
                                                    <c:forEach items="${book.authors}" var="authorName" varStatus="status">
                                                        ${authorName}<c:if test="${not status.last}">, </c:if>
                                                    </c:forEach>
                                                </p>
                                                <div class="flex items-center gap-1">
                                                    <c:forEach begin="1" end="${book.averageRating}">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-star w-3 h-3 md:w-4 md:h-4 fill-accent text-accent" aria-hidden="true">
                                                            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                                        </svg>
                                                    </c:forEach>
                                                    <c:forEach begin="1" end="${5 - book.averageRating}">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-star w-3 h-3 md:w-4 md:h-4 text-accent" aria-hidden="true">
                                                            <path d="M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z"></path>
                                                        </svg>
                                                    </c:forEach>
                                                </div>
                                                <p class="text-xs md:text-sm text-muted-foreground mt-2 line-clamp-3">${book.description}</p>
                                            </div>

                                            <div class="flex items-center justify-between pt-3 border-t border-border/50 mt-3">
                                                <span class="font-bold text-primary text-sm md:text-base line-clamp-1">${book.price} EGP</span>
                                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                                    <input type="hidden" name="formAction" value="remove-wishlist"/>
                                                    <input type="hidden" name="bookId" value="${book.id}"/>
                                                    <button type="submit"
                                                            data-remove-wishlist-button
                                                            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium transition-all cursor-pointer shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] h-8 rounded-md gap-1.5 px-3 border border-red-500/30 bg-red-500/10 text-red-500 hover:bg-red-500/20">
                                                        Remove
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="addresses-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <div class="flex flex-col gap-2 mb-6">
                        <h2 class="text-2xl font-bold text-foreground">Saved Addresses</h2>
                        <p class="text-sm text-muted-foreground">Add a new address here, or save over an existing address by choosing the same address type.</p>
                    </div>

                    <div class="grid grid-cols-1 xl:grid-cols-[1fr_1.15fr] gap-6">
                        <form action="${pageContext.request.contextPath}/profile" method="post" class="rounded-xl border border-border bg-background p-5 space-y-4">
                            <input type="hidden" name="formAction" value="save-address"/>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">Address Type</label>
                                    <select name="addressType" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" required>
                                        <c:forEach items="${requestScope.addressTypes}" var="addressType">
                                            <option value="${addressType}">${addressType.prettyName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">Government</label>
                                    <select name="government" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" required>
                                        <c:forEach items="${requestScope.governments}" var="government">
                                            <option value="${government}">${government.prettyName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">City</label>
                                    <input type="text" name="city" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" required/>
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-foreground mb-2">Building No</label>
                                    <input type="text" name="buildingNo" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" required/>
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Street</label>
                                <input type="text" name="street" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" required/>
                            </div>

                            <div>
                                <label class="block text-sm font-semibold text-foreground mb-2">Description</label>
                                <textarea name="description" rows="3" class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary resize-y"></textarea>
                            </div>

                            <button type="submit" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">Save Address</button>
                        </form>

                        <div class="space-y-4">
                            <c:choose>
                                <c:when test="${empty requestScope.profileAddresses or empty requestScope.profileAddresses.addresses}">
                                    <div class="rounded-lg border border-dashed border-border px-6 py-8 text-center text-muted-foreground">
                                        No saved addresses found for your account yet.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${requestScope.profileAddresses.addresses}" var="address">
                                        <div class="rounded-xl border border-border bg-background p-5">
                                            <div class="flex flex-col gap-3 md:flex-row md:items-start md:justify-between">
                                                <div class="space-y-2">
                                                    <p class="font-semibold text-foreground">${address.addressType.prettyName}</p>
                                                    <p class="text-sm text-muted-foreground">${address.street}, Building ${address.buildingNo}</p>
                                                    <p class="text-sm text-muted-foreground">${address.city}, ${address.government.prettyName}</p>
                                                    <c:if test="${not empty address.description}">
                                                        <p class="text-sm text-muted-foreground">${address.description}</p>
                                                    </c:if>
                                                </div>

                                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                                    <input type="hidden" name="formAction" value="delete-address"/>
                                                    <input type="hidden" name="addressId" value="${address.id}"/>
                                                    <button type="submit" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium h-9 px-4 py-2 border border-red-500/30 bg-red-500/10 text-red-500 hover:bg-red-500/20">Delete</button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div id="credit-manage-info" class="profile-panel hidden bg-card text-card-foreground rounded-xl border shadow-sm p-8">
                    <div class="flex flex-col gap-2 mb-6">
                        <h2 class="text-2xl font-bold text-foreground">Credit Management</h2>
                        <p class="text-sm text-muted-foreground">Manage the available credit for your account.</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/profile" method="post" class="space-y-6">
                        <input type="hidden" name="formAction" value="credit-settings"/>

                        <div>
                            <label class="block text-sm font-semibold text-foreground mb-2">Credit Limit</label>
                            <input type="number" name="creditLimit" step="0.01" min="0" required class="w-full px-4 py-2 rounded-lg border border-border bg-background text-foreground focus:outline-none focus:ring-2 focus:ring-primary" value="${requestScope.profileUser.creditLimit}"/>
                            <p class="mt-2 text-sm text-muted-foreground">This value comes from the backend and updates your available account balance.</p>
                        </div>

                        <button type="submit" class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium text-primary-foreground h-9 px-4 py-2 bg-primary hover:bg-primary/90">Save Credit Settings</button>
                    </form>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="../common/footer.jsp"/>
</div>
<script type="module">
    import { initHeader } from "${pageContext.request.contextPath}/assets/js/common/header.js";

    initHeader();

    const profileTabs = document.querySelectorAll(".profile-tab");
    const profilePanels = document.querySelectorAll(".profile-panel");
    const initialTab = "${empty requestScope.profile_active_tab ? 'profile-info' : requestScope.profile_active_tab}";

    function showProfilePanel(tabId) {
        profilePanels.forEach((panel) => {
            panel.classList.toggle("hidden", panel.id !== tabId);
        });
        profileTabs.forEach((btn) => {
            const isActive = btn.dataset.tab === tabId;
            btn.classList.toggle("bg-primary", isActive);
            btn.classList.toggle("text-background", isActive);
            btn.classList.toggle("hover:bg-accent", !isActive);
            btn.classList.toggle("text-foreground", !isActive);
        });
    }

    profileTabs.forEach((tab) => {
        tab.addEventListener("click", () => showProfilePanel(tab.dataset.tab));
    });

    showProfilePanel(initialTab);

    const profileForm = document.getElementById("profile-update-form");
    const currentPasswordInput = document.getElementById("currentPassword");
    const newPasswordInput = document.getElementById("newPassword");
    const confirmNewPasswordInput = document.getElementById("confirmNewPassword");
    const passwordValidationMessage = document.getElementById("password-validation-message");
    const profileInterestCheckboxes = Array.from(document.querySelectorAll(".profile-interest-checkbox"));
    const profileSelectedInterestsContainer = document.getElementById("profile-selected-interests");
    const profileSelectedInterestsCount = document.getElementById("profile-selected-interests-count");

    function renderSelectedInterests() {
        if (!profileSelectedInterestsContainer || !profileSelectedInterestsCount) {
            return;
        }

        const selectedInterests = profileInterestCheckboxes
            .filter((checkbox) => checkbox.checked)
            .map((checkbox) => ({
                name: checkbox.dataset.interestName || ""
            }));

        profileSelectedInterestsContainer.innerHTML = "";

        if (selectedInterests.length === 0) {
            const emptyState = document.createElement("p");
            emptyState.className = "text-sm text-muted-foreground";
            emptyState.textContent = "No interests selected yet.";
            profileSelectedInterestsContainer.appendChild(emptyState);
        } else {
            selectedInterests
                .sort((left, right) => left.name.localeCompare(right.name))
                .forEach((interest) => {
                    const chip = document.createElement("span");
                    chip.className = "inline-flex items-center rounded-full border border-primary/20 bg-primary/10 px-3 py-1 text-sm font-medium text-primary";
                    chip.textContent = interest.name;
                    profileSelectedInterestsContainer.appendChild(chip);
                });
        }

        profileSelectedInterestsCount.textContent = `${selectedInterests.length} selected`;

        profileInterestCheckboxes.forEach((checkbox) => {
            const optionCard = checkbox.closest("[data-interest-option]");
            if (!optionCard) {
                return;
            }

            optionCard.classList.toggle("border-primary/40", checkbox.checked);
            optionCard.classList.toggle("bg-primary/5", checkbox.checked);
        });
    }

    profileInterestCheckboxes.forEach((checkbox) => {
        checkbox.addEventListener("change", renderSelectedInterests);
    });
    renderSelectedInterests();

    function resetPasswordFieldValidation() {
        [currentPasswordInput, newPasswordInput, confirmNewPasswordInput].forEach((input) => input?.setCustomValidity(""));
    }

    function validatePasswordFields() {
        if (!currentPasswordInput || !newPasswordInput || !confirmNewPasswordInput) {
            return true;
        }

        resetPasswordFieldValidation();

        const currentPassword = currentPasswordInput.value;
        const newPassword = newPasswordInput.value;
        const confirmNewPassword = confirmNewPasswordInput.value;
        const wantsPasswordChange = currentPassword || newPassword || confirmNewPassword;

        if (!wantsPasswordChange) {
            if (passwordValidationMessage) {
                passwordValidationMessage.textContent = "";
                passwordValidationMessage.classList.remove("text-red-500", "text-emerald-500");
                passwordValidationMessage.classList.add("text-muted-foreground");
            }
            return true;
        }

        let firstMessage = "";

        if (!currentPassword) {
            currentPasswordInput.setCustomValidity("Current password is required.");
            firstMessage = firstMessage || "Enter your current password to change it.";
        }
        if (!newPassword) {
            newPasswordInput.setCustomValidity("New password is required.");
            firstMessage = firstMessage || "Enter a new password.";
        } else {
            if (newPassword.length < 8) {
                newPasswordInput.setCustomValidity("New password must be at least 8 characters long.");
                firstMessage = firstMessage || "New password must be at least 8 characters long.";
            } else if (currentPassword && currentPassword === newPassword) {
                newPasswordInput.setCustomValidity("New password must be different from the current password.");
                firstMessage = firstMessage || "New password must be different from the current password.";
            }
        }

        if (!confirmNewPassword) {
            confirmNewPasswordInput.setCustomValidity("Please retype the new password.");
            firstMessage = firstMessage || "Please retype the new password.";
        } else if (newPassword && confirmNewPassword !== newPassword) {
            confirmNewPasswordInput.setCustomValidity("Passwords do not match.");
            firstMessage = firstMessage || "Retyped password must match the new password.";
        }

        if (passwordValidationMessage) {
            passwordValidationMessage.textContent = firstMessage || "Password change looks good.";
            passwordValidationMessage.classList.toggle("text-red-500", Boolean(firstMessage));
            passwordValidationMessage.classList.toggle("text-emerald-500", !firstMessage);
            passwordValidationMessage.classList.remove("text-muted-foreground");
        }

        return !firstMessage;
    }

    [currentPasswordInput, newPasswordInput, confirmNewPasswordInput].forEach((input) => {
        input?.addEventListener("input", validatePasswordFields);
    });

    profileForm?.addEventListener("submit", (event) => {
        const isPasswordValid = validatePasswordFields();

        if (!isPasswordValid) {
            event.preventDefault();
            [currentPasswordInput, newPasswordInput, confirmNewPasswordInput]
                .find((input) => input && !input.checkValidity())
                ?.reportValidity();
        }
    });
</script>
</body>
</html>
