import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import plotly.express as px

import pandas as pd

df = pd.read_csv('C:/Users/ncordova/Downloads/auto-mpg.csv')

app = dash.Dash(__name__)

fig = px.scatter(df, x="displacement", y="weight",
                    log_x=True, size_max=55, trendline="ols")

app.layout = html.Div(children=[
    html.H1("Displacement vs Weight"),
    html.Img(
        src='https://cdn.autobild.es/sites/navi.axelspringer.es/public/media/image/2017/02/futuro-clasico-alfa-romeo-4c.jpg',
        style = {'width': '80%'}),
    dcc.Graph(
        figure=fig
    )
])
    

if __name__ == '__main__':
    app.run_server(debug=True,use_reloader=False)