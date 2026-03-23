/**
 * hero-slider.js
 * Auto-advances every 5s. Prev/Next arrows, dot nav, progress bar, swipe, keyboard.
 * Click on the slider body toggles pause/resume (progress bar pauses visually too).
 * No existing logic modified — pause/resume is purely additive.
 */
(function () {
    const INTERVAL = 5000;

    const slides = document.querySelectorAll('.hero-slide');
    const dots = document.querySelectorAll('.hero-dot');
    const prev = document.getElementById('heroPrev');
    const next = document.getElementById('heroNext');
    const progress = document.getElementById('heroProgress');
    const slider = document.getElementById('heroSlider');

    if (!slides.length) return;

    let current = 0;
    let timer = null;
    let paused = false;

    /* Slide transition */
    function goTo(index) {
        slides[current].classList.remove('active');
        slides[current].classList.add('exit');
        dots[current].classList.remove('active');

        const old = current;
        setTimeout(() => slides[old].classList.remove('exit'), 900);

        current = (index + slides.length) % slides.length;
        slides[current].classList.add('active');
        dots[current].classList.add('active');

        restartProgress();
    }

    /* Progress bar */
    function restartProgress() {
        if (!progress) return;
        progress.style.animation = 'none';
        void progress.offsetWidth;
        if (!paused) {
            progress.style.animation = `heroProg ${INTERVAL}ms linear forwards`;
        }
    }

    function pauseProgress() {
        if (!progress) return;
        // Freeze the bar at its current width by reading computed width
        const computed = getComputedStyle(progress).width;
        progress.style.animation = 'none';
        progress.style.width = computed;
    }

    function resumeProgress() {
        if (!progress) return;
        // Restart from zero for the full interval
        progress.style.width = '';
        progress.style.animation = `heroProg ${INTERVAL}ms linear forwards`;
    }

    /* Auto-play */
    function startAuto() {
        clearInterval(timer);
        timer = setInterval(() => goTo(current + 1), INTERVAL);
    }

    function stopAuto() {
        clearInterval(timer);
    }

    /* Toggle pause on slider click */
    if (slider) {
        slider.addEventListener('click', (e) => {
            // Don't toggle when clicking arrows or dots — those have their own action
            if (e.target.closest('.hero-arrow, .hero-dot')) return;

            paused = !paused;

            if (paused) {
                stopAuto();
                pauseProgress();
                slider.classList.add('hero-paused');
            } else {
                startAuto();
                resumeProgress();
                slider.classList.remove('hero-paused');
            }
        });
    }

    /* Hover pause (existing behavior, unchanged) */
    if (slider) {
        slider.addEventListener('mouseenter', () => {
            if (!paused) stopAuto();
        });
        slider.addEventListener('mouseleave', () => {
            if (!paused) startAuto();
        });
    }

    /* Arrow buttons */
    if (prev) prev.addEventListener('click', () => {
        goTo(current - 1);
        if (!paused) startAuto();
    });
    if (next) next.addEventListener('click', () => {
        goTo(current + 1);
        if (!paused) startAuto();
    });

    /* Dot navigation */
    dots.forEach((dot, i) => dot.addEventListener('click', () => {
        goTo(i);
        if (!paused) startAuto();
    }));

    /* Keyboard */
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft') {
            goTo(current - 1);
            if (!paused) startAuto();
        }
        if (e.key === 'ArrowRight') {
            goTo(current + 1);
            if (!paused) startAuto();
        }
    });

    /* Touch / swipe */
    let tx = 0;
    if (slider) {
        slider.addEventListener('touchstart', (e) => {
            tx = e.changedTouches[0].clientX;
        }, {passive: true});
        slider.addEventListener('touchend', (e) => {
            const d = tx - e.changedTouches[0].clientX;
            if (Math.abs(d) > 40) {
                d > 0 ? goTo(current + 1) : goTo(current - 1);
                if (!paused) startAuto();
            }
        }, {passive: true});
    }

    /* Boot */
    restartProgress();
    startAuto();
})();
