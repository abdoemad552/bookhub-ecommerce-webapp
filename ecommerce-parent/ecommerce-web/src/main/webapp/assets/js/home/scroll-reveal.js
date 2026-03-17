/**
 * scroll-reveal.js
 * Adds .revealed to every .reveal element when it enters the viewport.
 * One-time animation. No existing logic modified.
 */
(function () {
    const targets = document.querySelectorAll('.reveal');
    if (!targets.length) return;

    const io = new IntersectionObserver(
        (entries) => {
            entries.forEach((e) => {
                if (e.isIntersecting) {
                    e.target.classList.add('revealed');
                    io.unobserve(e.target);
                }
            });
        },
        { threshold: 0.1, rootMargin: '0px 0px -32px 0px' }
    );

    targets.forEach((el) => io.observe(el));
})();
