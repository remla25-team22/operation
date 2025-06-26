# Hypothesis
Reducing the vectorizer dimensionality from 1000 to 100 features will raise the incorrect-prediction rate by no more than 2 percentage points after each version has logged 5 000 predictions.



## Design
- Two deployments: v1 (baseline), v2 (reduced feature count).
- Sticky sessions (cookie `app-session`) keep every user on one app-service pod
- App-service and model-service are synchronized for requests
- User feedback is always matched with the same model version.


## Experimental Design  

| Element | Details |
|---------|---------|
| Versions under test | `app-service v1 ↔ model-service v1` (baseline)  `app-service v2 ↔ model-service v2` (100-feature vectorizer) |
| Traffic policy | Sticky sessions are used to have a fixed model and app version per session. Cookie **`app-session`** then keeps every user on one pod for the rest of the session. |
| Feedback loop | The app records whether the model answer was correct.  It updates a gauge named `incorrect_prediction_rate{version="v*"}`. |

---
## Metric Definition  
Incorrect_prediction_rate of type gauge is used. 
For example:
```
incorrect_prediction_rate{version="v1"} 0.215
incorrect_prediction_rate{version="v2"} 0.308
```

Prometheus scrapes /metrics every 15 s.

## Grafana dashboard
![Alt text](./dashboards/a5-continous-experimentation-dashboard.png)


Dashboard JSON: dashboard/grafana-experiment.json

## Decision rule  

After 5000 predictions per version:

- Accept v2 if
`avg_over_time(incorrect_prediction_rate{version="v2"}[1h])
≤ avg_over_time(incorrect_prediction_rate{version="v1"}[1h]) + 0.02` with the statistical significance test.
- Otherwise keep v1 and retire v2.







