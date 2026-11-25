.pragma library

const WEEKDAYS = ["M", "T", "W", "T", "F", "S", "S"];
const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
const DAYS_PER_WEEK = 7;

function weekdays() {
    return WEEKDAYS;
}

function monthName(month) {
    return MONTHS[((month % 12) + 12) % 12];
}

function shift(year, month, delta) {
    const index = year * 12 + month + delta;
    return { year: Math.floor(index / 12), month: ((index % 12) + 12) % 12 };
}

function daysIn(year, month) {
    return new Date(year, month + 1, 0).getDate();
}

function leadingBlanks(year, month) {
    const sundayFirst = new Date(year, month, 1).getDay();
    return (sundayFirst + 6) % DAYS_PER_WEEK;
}

function cells(year, month, today) {
    const result = [];
    for (let blank = 0; blank < leadingBlanks(year, month); blank++) result.push({ day: 0, today: false });
    const total = daysIn(year, month);
    for (let day = 1; day <= total; day++) {
        const isToday = !!today && today.getFullYear() === year && today.getMonth() === month && today.getDate() === day;
        result.push({ day: day, today: isToday });
    }
    return result;
}
