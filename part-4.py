import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output
import plotly.express as px

import pandas as pd

df = pd.read_csv('C:/Users/ncordova/Downloads/auto-mpg.csv')
df['hp'] = df['horsepower']
df['cyl'] = df['cylinders']
df = df[df.hp != "?"]
df["hp"] = df["hp"].astype(int)

app = dash.Dash(__name__)

app.layout = html.Div(children=[
    html.H1(children='Histograma', style={'color':'black'}),
    dcc.Graph(id="Grafico_horsepower"),
    dcc.Dropdown(
        id='cylinder-dropdown',
        options=[{'label':i, 'value':i} for i in df['cyl'].unique()],
        value= '4'
        ),
])

@app.callback(
    Output('Grafico_horsepower', 'figure'),
    Input('cylinder-dropdown', 'value')
)
def update_figure(selected_cylinder):
    filtered_df = df[df.cyl == selected_cylinder]

    fig= px.histogram(filtered_df, x='hp')

    fig.update_layout(transition_duration=400)
    
    return fig

if __name__ == '__main__':
    app.run_server(debug=True,use_reloader=False)