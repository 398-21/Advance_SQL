const express = require('express');
const app = express();
const pool = require('./db');  // Use the connection pool
const path = require('path');

app.use(express.static(path.join(__dirname, 'public')));

// Endpoint to get peak hours for taxi demand
app.get('/peak-hours', (req, res) => {
    const query = `
        SELECT HOUR(pickup_datetime) AS hour, COUNT(*) AS count 
        FROM Trips 
        GROUP BY hour 
        ORDER BY count DESC
    `;
    pool.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Endpoint to get average fare amount by hour
app.get('/average-fare', (req, res) => {
    const query = `
        SELECT HOUR(pickup_datetime) AS hour, AVG(fare_amount) AS avg_fare 
        FROM Trips 
        GROUP BY hour 
        ORDER BY hour
    `;
    pool.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Endpoint to get areas with highest demand for taxis
app.get('/highest-demand-areas', (req, res) => {
    const query = `
        SELECT Z.zone_name, COUNT(*) AS count 
        FROM Trips T
        JOIN Locations L ON T.pickup_location_id = L.location_id
        JOIN Zones Z ON L.zone_id = Z.zone_id
        GROUP BY Z.zone_name 
        ORDER BY count DESC 
        LIMIT 10
    `;
    pool.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Endpoint to get the effect of weather on average fare amount
app.get('/weather-affect', (req, res) => {
    const query = `
        SELECT C.conditions AS weather_condition, AVG(T.fare_amount) AS avg_fare
        FROM Trips T
        JOIN Datetimes D ON T.pickup_datetime = D.datetime
        JOIN Weather W ON D.datetime_id = W.datetime_id
        JOIN Conditions C ON W.condition_id = C.condition_id
        GROUP BY weather_condition
        ORDER BY avg_fare DESC
    `;
    pool.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Endpoint to get fare by zone during peak hours
app.get('/fare-by-zone-peak-hours', (req, res) => {
    const query = `
        WITH PeakHoursTrips AS (
            SELECT t.trip_id, t.pickup_datetime, t.fare_amount, l.zone_id AS pickup_zone_id, z.zone_name AS pickup_zone_name
            FROM Trips t
            JOIN Locations l ON t.pickup_location_id = l.location_id
            JOIN Zones z ON l.zone_id = z.zone_id
            WHERE (HOUR(t.pickup_datetime) BETWEEN 7 AND 9 OR HOUR(t.pickup_datetime) BETWEEN 17 AND 19)
        ),
        AverageFarePerZone AS (
            SELECT pzt.pickup_zone_name, AVG(pzt.fare_amount) AS average_fare_amount
            FROM PeakHoursTrips pzt
            GROUP BY pzt.pickup_zone_name
        )
        SELECT afz.pickup_zone_name, afz.average_fare_amount, (SELECT AVG(fare_amount) FROM Trips) AS overall_average_fare, afz.average_fare_amount - (SELECT AVG(fare_amount) FROM Trips) AS fare_difference
        FROM AverageFarePerZone afz
        ORDER BY fare_difference DESC
    `;
    pool.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Endpoint to get correlation of payment methods with trip distance and fare
app.get('/payment-methods-correlation', (req, res) => {
    const query = `
        SELECT P.payment_type_description AS payment_type,  AVG(T.trip_distance) AS avg_distance,  AVG(T.fare_amount) AS avg_fare 
        FROM Trips T
        JOIN PaymentTypes P ON T.payment_type = P.payment_type_id
        GROUP BY P.payment_type_description
        ORDER BY avg_fare DESC
    `;
    pool.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
